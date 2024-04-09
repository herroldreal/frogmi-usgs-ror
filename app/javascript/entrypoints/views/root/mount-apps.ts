import RootApp from "@/entrypoints/views/root/RootApp.vue";
import { mountComponent } from "@/helpers/mount-component";

/**
 * Mounts the RootApp Vue component onto the specified element.
 * @returns {Vue} The mounted Vue instance.
 */
const mountRootApp = () => {
    try {
        return mountComponent("#root-view", RootApp);
    } catch (error) {
        console.error("Error mounting RootApp:", error);
    }
};

export { mountRootApp };