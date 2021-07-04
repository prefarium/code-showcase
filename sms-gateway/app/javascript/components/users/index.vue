<template>
  <div>
    <p class="custom-title d-inline-block">Клиенты системы</p>

    <router-link to="/users/new" class="float-end">
      <button class="btn btn-danger custom-rounded" style="margin-top: -0.75rem">Добавить клиента</button>
    </router-link>

    <div class="bg-white px-4 py-3 custom-rounded mb-4">
      <div class="row">
        <div class="col">
          <multiselect v-model="selectedUser"
                       :options="userNames"
                       track-by="id"
                       label="name"
                       :show-labels="false"
                       placeholder="Клиент">
          </multiselect>
        </div>

        <div class="col">
          <multiselect v-model="selectedProvider"
                       :options="providerNames"
                       track-by="id"
                       label="name"
                       :show-labels="false"
                       placeholder="Провайдер">
          </multiselect>
        </div>

        <div class="col">
          <date-picker class="custom-datepicker"
                       v-model="selectedDates"
                       type="date"
                       format="DD.MM.YYYY"
                       value-type="format"
                       placeholder="Период подключения"
                       :clearable="true"
                       range
                       range-separator=" - "/>
        </div>
      </div>
    </div>

    <div class="bg-white p-4 custom-rounded">
      <table class="table table-bordered custom-border m-0">
        <thead>
        <tr>
          <th scope="col" class="custom-title">Имя клиента</th>
          <th scope="col" class="custom-title">Имя провайдера</th>
          <th scope="col" class="custom-title">Имя отправителя</th>
          <th scope="col" class="custom-title">Дата подключения</th>
          <th scope="col" class="custom-title">Токен</th>
        </tr>
        </thead>

        <tbody v-for="(user, key) in this.usersData" :key="key">
        <tr v-for="(infoItem, key) in user.info" :key="key">
          <td valign="top" :rowspan="user.info.length" v-if="key === 0">
            {{ user.name }}
          </td>
          <td>{{ infoItem.provider_name }}</td>
          <td>{{ infoItem.sender_name }}</td>
          <td>{{ parseDate(infoItem.connection_date) }}</td>
          <td>{{ infoItem.token }}</td>
        </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import DatePicker  from 'vue2-datepicker';
import moment      from "moment";
import Multiselect from 'vue-multiselect';

import { names as getProviderNames } from '../../lib/api/providers';

import {
  names as getUserNames,
  index as getUsers
} from '../../lib/api/users';

export default {
  data() {
    return {
      getUsersRequestParams: {
        date_from:   null,
        date_to:     null,
        provider_id: null,
        user_id:     null,
      },

      providerNames: [],
      userNames:     [],
      usersData:     [],

      selectedDates:    null,
      selectedProvider: null,
      selectedUser:     null,
    };
  },

  components: {
    DatePicker,
    Multiselect,
  },

  watch: {
    selectedDates: {
      deep: true,
      handler(dates) {
        this.getUsersRequestParams.date_from = dates[0];
        this.getUsersRequestParams.date_to   = dates[1];
        this.updateUsersTable();
      },
    },

    selectedProvider(provider) {
      this.getUsersRequestParams.provider_id = _.get(provider, 'id', null);
      this.updateUsersTable();
    },

    selectedUser(user) {
      this.getUsersRequestParams.user_id = _.get(user, 'id', null);
      this.updateUsersTable();
    },
  },

  methods: {
    parseDate(date) {
      return moment(date).format('DD.MM.YY');
    },

    updateUsersTable() {
      getUsers(this.getUsersRequestParams)
          .then(({ data }) => { this.usersData = data });
    },
  },

  created() {
    getUserNames().then(({ data }) => { this.userNames = data });
    getProviderNames().then(({ data }) => { this.providerNames = data });
    this.updateUsersTable();
  },
}
</script>
