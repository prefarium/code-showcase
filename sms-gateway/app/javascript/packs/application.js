// <== Rails defaults ==>

import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"

Rails.start()
ActiveStorage.start()

// <== End of Rails defaults ==>

// <== Creating VueJS application ==>

import Vue    from 'vue/dist/vue.esm';
import * as _ from 'lodash';
import moment from 'moment';

import 'bootstrap/dist/js/bootstrap';
import 'vue2-datepicker/locale/ru';

import App    from '../components/layout/app.vue';
import router from '../lib/routes';
import store  from '../stores/store';
import '../css/application.scss';

moment.locale('ru');
window.moment = moment;

Vue.prototype._ = _;
window._ = _;
Vue.config.productionTip = false;

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    router,
    store,
    render: h => h(App)
  }).$mount("#vue-app");
});

// <== End of creating VueJS application ==>
