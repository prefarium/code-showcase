<template>
  <div>
    <div class="bg-white p-4 custom-rounded">
      <table class="table table-bordered custom-border m-0">
        <thead>
        <tr>
          <th scope="col" class="custom-title">Имя провайдера</th>
          <th scope="col" class="custom-title">Остаток средств, рубли</th>
          <th scope="col" class="custom-title">Дата регистрации</th>
        </tr>
        </thead>
        <tbody>
        <tr v-for="provider in this.providersData">
          <th scope="row">{{ provider.name }}</th>
          <td>{{ provider.balance }}</td>
          <td>{{ parseDate(provider.date) }}</td>
        </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import moment from "moment";

import { index as getProviders } from '../../lib/api/providers';

export default {
  data() {
    return {
      providersData: [],
    };
  },

  methods: {
    parseDate(date) {
      return moment(date).format('DD.MM.YYYY');
    },
  },

  created() {
    getProviders().then(({ data }) => { this.providersData = data });
  }
}
</script>
