import Vue  from 'vue/dist/vue.esm';
import Vuex from 'vuex';

import MessagesStore   from "./messages_store";

Vue.use(Vuex);

const store = new Vuex.Store({
  modules: {
    messagesStore:   MessagesStore,
  },
});

export default store;
