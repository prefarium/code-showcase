import Vue       from 'vue/dist/vue.esm';
import VueRouter from 'vue-router';

import Home from '../components/home/main.vue';

import Admins      from '../components/messages/main.vue';
import AdminsIndex from '../components/admins/index.vue';
import AdminsNew   from '../components/admins/new.vue';

import Messages      from '../components/messages/main.vue';
import MessagesIndex from '../components/messages/index.vue';
import MessagesNew   from '../components/messages/new.vue';

import Providers      from '../components/providers/main.vue';
import ProvidersIndex from '../components/providers/index.vue';

import Statistics from '../components/statistics/main.vue';

import Users      from '../components/users/main.vue';
import UsersIndex from '../components/users/index.vue';
import UsersNew   from '../components/users/new.vue';

const routes = [
  {
    path: '/', name: 'Home', component: Home,
  },

  {
    path:     '/admins', name: 'Admins', component: Admins,
    children: [
      { path: 'index', name: 'AdminsIndex', component: AdminsIndex },
      { path: 'new', name: 'AdminsNew', component: AdminsNew }
    ],
  },

  {
    path:     '/messages', name: 'Messages', component: Messages,
    children: [
      { path: 'index', name: 'MessagesIndex', component: MessagesIndex },
      { path: 'new', name: 'MessagesNew', component: MessagesNew }
    ],
  },

  {
    path:     '/providers', name: 'Providers', component: Providers,
    children: [
      { path: 'index', name: 'ProvidersIndex', component: ProvidersIndex },
    ],
  },

  {
    path: '/statistics', name: 'Statistics', component: Statistics,
  },

  {
    path:     '/users', name: 'Users', component: Users,
    children: [
      { path: 'index', name: 'UsersIndex', component: UsersIndex },
      { path: 'new', name: 'UsersNew', component: UsersNew },
    ]
  },
];

Vue.use(VueRouter);

const router = new VueRouter({
  routes,
  mode: 'history',
});

export default router;
