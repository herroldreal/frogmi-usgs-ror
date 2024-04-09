<script setup lang="ts">
import {ref, onMounted, computed, watch, nextTick} from 'vue';
import axios from 'axios';

// Initialize reactive variables
const features = ref([]);
const paginationRef = ref({});
const serverItems = ref([]);
const loadingText = ref("Loading... Please wait");
const loading = ref(true);
const comment = ref("");
const dialog = ref(false);
const editedIndex = ref(-1);
const snackbar = ref(false);
const snackText = ref('');
const vertical = ref(true);
const timeout = 2000;
const editedItem = ref({
  "id": 0,
  "type": "feature",
  "attributes": {
    "external_id": "",
    "magnitude": "",
    "place": "",
    "time": "",
    "tsunami": false,
    "mag_type": "",
    "title": "",
    "coordinates": {
      "latitude": "0",
      "longitude": "0"
    }
  },
  "links": {
    "external_url": ""
  }
})
let originalItems = [];

const headers = [
  {title: 'ID', key: 'id', sortable: false},
  {title: 'Title', key: 'attributes.title', sortable: false},
  {title: 'Place', key: 'attributes.place', sortable: false},
  {title: 'Magnitude', key: 'attributes.magnitude', sortable: true},
  {title: 'Tsunami', key: 'attributes.tsunami', sortable: true},
  {title: 'Time', key: 'attributes.time', sortable: true},
  {title: 'Latitude', key: 'attributes.coordinates.latitude', sortable: false},
  {title: 'Longitude', key: 'attributes.coordinates.longitude', sortable: false},
  {title: '', key: 'actions', sortable: false},
];

// Fetch features data on component mount
onMounted(async () => {
  try {
    const response = await fetch('api/features');
    if (response.ok) {
      const {data, pagination} = await response.json();
      features.value = data;
      paginationRef.value = pagination;
    } else {
      console.error('Error loading data', response.statusText);
    }
  } catch (e) {
    console.error(e);
  }
});

// Watch for changes in dialog state and close dialog when it's false
watch(dialog, (newValue, oldValue) => {
  if (!newValue) closeDialog();
});

// Initialize default item object
const defaultItem = ref({
  id: 0,
  type: 'feature',
  attributes: {
    external_id: '',
    magnitude: '',
    place: '',
    time: '',
    tsunami: false,
    mag_type: '',
    title: '',
    coordinates: {latitude: '0', longitude: '0'}
  },
  links: {external_url: ''}
});

// Edit item
const editItem = (item) => {
  editedIndex.value = features.value.indexOf(item);
  editedItem.value = {...item};
  dialog.value = true;
};

// Close dialog
const closeDialog = () => {
  dialog.value = false;
  comment.value = '';
  nextTick(() => {
    editedItem.value = {...defaultItem.value};
    editedIndex.value = -1;
  });
};

// Save comment
const save = async () => {
  try {
    const response = await axios.post(`/api/features/${editedItem.value.id}/comments/`, {body: comment.value});
    snackText.value = response.status >= 200 && response.status < 300 ? 'Comment created successfully' : response.statusText;
    snackbar.value = true;
    closeDialog();
  } catch (error) {
    console.error('Error saving comment:', error);
    snackText.value = 'Error saving comment';
    snackbar.value = true;
  }
};

// Load items with pagination and sorting
const loadItems = async ({page, itemsPerPage, sortBy}) => {
  loading.value = true;
  const startIndex = (page - 1) * itemsPerPage;
  const endIndex = startIndex + itemsPerPage;
  let items = [];
  if (serverItems.value.length >= endIndex) {
    items = serverItems.value.slice(startIndex, endIndex);
  } else {
    try {
      const response = await fetch(`/api/features?page=${page}&per_page=${itemsPerPage}`);
      console.log(`URL => /api/features?page=${page}&per_page=${itemsPerPage}`)
      if (response.ok) {
        const {data, pagination} = await response.json();
        originalItems = [...originalItems, ...data];
        paginationRef.value = pagination;
        items = data;
      } else {
        console.error('Error loading data', response.statusText);
        loading.value = false;
        return;
      }
    } catch (error) {
      console.error('Error loading data:', error);
      loading.value = false;
      return;
    }
  }
  if (sortBy.length) {
    const sortKey = sortBy[0].key;
    const sortOrder = sortBy[0].order;
    items.sort((a, b) => {
      const aValue = a.attributes[sortKey.replace('attributes.', '')];
      const bValue = b.attributes[sortKey.replace('attributes.', '')];
      return sortOrder === 'desc' ? bValue - aValue : aValue - bValue;
    });
  }
  serverItems.value = items;
  loading.value = false;
};
</script>

<template>
  <v-container fill-height fluid>
    <v-col align="start"
           justify="center">

      <v-row justify="center" no-gutters>
        <v-col align-self="center">
          <section>
            <h1 class="text-2xl mb-2">Informacion Sismica Mundial (USGS)</h1>
          </section>
          <img
              alt="Vue logo"
              class="logo block"
              src="@/assets/logo.png"
              height="250"
              width="450"
          />
        </v-col>
      </v-row>

      <v-row>
        <main>
          <v-container>
            <v-row>
              <v-col>
                <v-card>
                  <v-card-text>
                    <v-data-table-server
                        v-model:items-per-page="paginationRef.per_page"
                        :headers="headers"
                        :items="serverItems"
                        :items-length="paginationRef.total"
                        :loading-text="loadingText"
                        :loading="loading"
                        @update:options="loadItems"
                    >
                      <template v-slot:top>
                        <v-toolbar flat>
                          <v-toolbar-title>Datos Sismicos (ultimos 30 dias)</v-toolbar-title>
                          <v-dialog
                              v-model="dialog"
                              max-width="500px"
                          >
                            <v-card>
                              <v-card-title>
                                <span class="text-h5">Agregar comentario</span>
                              </v-card-title>

                              <v-card-text>
                                <v-container>
                                  <v-row>
                                    <v-col
                                        cols="12"
                                        md="12"
                                        sm="12"
                                    >
                                      <v-textarea
                                          v-model="comment"
                                          label="Comentario"
                                      ></v-textarea>
                                    </v-col>
                                  </v-row>
                                </v-container>
                              </v-card-text>

                              <v-card-actions>
                                <v-spacer></v-spacer>
                                <v-btn
                                    color="blue-darken-1"
                                    variant="text"
                                    @click="closeDialog"
                                >
                                  Cancelar
                                </v-btn>
                                <v-btn
                                    color="blue-darken-1"
                                    variant="text"
                                    @click="save"
                                >
                                  Guardar
                                </v-btn>
                              </v-card-actions>
                            </v-card>
                          </v-dialog>
                        </v-toolbar>
                      </template>

                      <template v-slot:item.attributes.time="{ item }">
                        <v-table class="v-data-table__td v-data-table-column--align-start">
                          {{ new Date(parseInt(item.attributes.time)).toLocaleString() }}
                        </v-table>
                      </template>

                      <template v-slot:item.actions="{ item }">
                        <v-chip
                            class="ma-2"
                            variant="elevated"
                            color="green"
                            @click="editItem(item)"
                        >
                          Editar
                        </v-chip>
                      </template>

                    </v-data-table-server>

                    <template>
                      <v-snackbar
                          v-model="snackbar"
                          :vertical="vertical"
                          :timeout="timeout"
                      >
                        {{ snackText }}
                        <template v-slot:action="{ attrs }">
                          <v-btn
                              color="indigo"
                              text="{{snackText}}"
                              v-bind="attrs"
                              @click="snackbar = false"
                          >
                            Close
                          </v-btn>
                        </template>
                      </v-snackbar>
                    </template>

                  </v-card-text>
                </v-card>
              </v-col>
            </v-row>
          </v-container>
        </main>
      </v-row>
    </v-col>
  </v-container>
</template>

<style scoped>
.logo {
  margin: 0 auto 2rem;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  .logo {
    margin: 0 2rem 0 0;
  }
}
</style>