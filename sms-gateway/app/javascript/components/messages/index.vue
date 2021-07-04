<template>
  <div>
    <p class="mb-6 custom-title">Журнал сообщений</p>

    <div class="bg-white px-4 py-3 custom-rounded mb-3">
      <div class="row mb-3">
        <div class="col">
          <multiselect v-model="selectedUser"
                       :options="userNames"
                       track-by="id"
                       label="name"
                       :show-labels="false"
                       placeholder="Клиент"/>
        </div>

        <div class="col">
          <multiselect v-model="selectedProvider"
                       :options="providerNames"
                       track-by="id"
                       label="name"
                       :show-labels="false"
                       placeholder="Провайдер"/>
        </div>

        <div class="col">
          <date-picker class="custom-datepicker"
                       v-model="selectedDates"
                       type="date"
                       format="DD.MM.YYYY"
                       value-type="format"
                       placeholder="Период"
                       :clearable="true"
                       range
                       range-separator=" - "/>
        </div>
      </div>

      <div class="row">
        <div class="input-group col">
          <input type="text"
                 class="form-control"
                 v-model="selectedTarget"
                 placeholder="Получатель, например 78005553535">
        </div>

        <div class="col">
          <multiselect v-model="selectedStatus"
                       :options="$store.state.messagesStore.statuses"
                       track-by="value"
                       label="name"
                       :show-labels="false"
                       placeholder="Статус">
          </multiselect>
        </div>
      </div>
    </div>

    <div class="row justify-content-center">
      <div class="col-auto">
        <pagination :current-page="currentPage" :total-pages="totalPages" @page="setPage"/>
      </div>
    </div>

    <div class="bg-white p-4 custom-rounded">
      <table class="table table-bordered custom-border m-0">
        <thead>
        <tr>
          <th scope="col" class="custom-title">Дата отправки</th>
          <th scope="col" class="custom-title">Отправитель</th>
          <th scope="col" class="custom-title">Провайдер</th>
          <th scope="col" class="custom-title">Получатель</th>
          <th scope="col" class="custom-title">Статус</th>
          <th scope="col" class="custom-title">Содержание</th>
        </tr>
        </thead>

        <tbody>
        <tr v-for="message in this.messages">
          <th style="width: 7%" scope="row">{{ parseDate(message.date) }}</th>
          <td style="width: 10%">{{ message.user_name }}</td>
          <td style="width: 10%">{{ message.provider_name }}</td>
          <td style="width: 10%">{{ message.target }}</td>
          <td style="width: 15%">{{ $store.state.messagesStore.statusesTranslator[message.status] }}</td>
          <td style="">{{ message.content }}</td>
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
import { names as getUserNames }     from '../../lib/api/users';
import { index as getMessages }      from '../../lib/api/messages';
import Pagination                    from '../layout/pagination'

export default {
  data() {
    return {
      getMessagesRequestParams: {
        date_from:   null,
        date_to:     null,
        page:        1,
        provider_id: null,
        status:      null,
        target:      null,
        user_id:     null,
      },

      providerNames: [],
      userNames:     [],
      messages:      [],
      currentPage:   1,
      totalPages:    1,

      selectedDates:    null,
      selectedProvider: null,
      selectedStatus:   null,
      selectedTarget:   null,
      selectedUser:     null,
    };
  },

  components: {
    DatePicker,
    Multiselect,
    Pagination,
  },

  watch: {
    selectedDates: {
      deep: true,
      handler(dates) {
        this.getMessagesRequestParams.date_from = dates[0];
        this.getMessagesRequestParams.date_to   = dates[1];
        this.getMessagesRequestParams.page      = 1;
        this.updateMessagesTable();
      },
    },

    selectedProvider(provider) {
      this.getMessagesRequestParams.provider_id = _.get(provider, 'id', null);
      this.getMessagesRequestParams.page        = 1;
      this.updateMessagesTable();
    },

    selectedStatus(status) {
      this.getMessagesRequestParams.status = _.get(status, 'value', null);
      this.getMessagesRequestParams.page   = 1;
      this.updateMessagesTable();
    },

    selectedTarget(target) {
      if (_.isEmpty(target)) {
        this.getMessagesRequestParams.target = null;
        this.getMessagesRequestParams.page   = 1;
        this.updateMessagesTable();
      } else if (target.match(/^\d{11}$/)) {
        this.getMessagesRequestParams.target = target;
        this.getMessagesRequestParams.page   = 1;
        this.updateMessagesTable();
      }
    },

    selectedUser(user) {
      this.getMessagesRequestParams.user_id = _.get(user, 'id', null);
      this.getMessagesRequestParams.page    = 1;
      this.updateMessagesTable();
    },
  },

  methods: {
    parseDate(date) {
      return moment(date).format('DD.MM.YY HH:mm');
    },

    updateMessagesTable() {
      getMessages(this.getMessagesRequestParams)
          .then(({ data }) => {
            this.messages = data.messages;

            if (!_.isNumber(this.totalPages) || this.totalPages !== data.total_pages) {
              this.currentPage = 1;
              this.totalPages  = data.total_pages;
            }
          });
    },

    setPage(page) {
      this.currentPage                   = page;
      this.getMessagesRequestParams.page = page;
      this.updateMessagesTable();
    }
  },

  created() {
    getUserNames().then(({ data }) => { this.userNames = data });
    getProviderNames().then(({ data }) => { this.providerNames = data });
    this.updateMessagesTable();
  }
}
</script>
