<template>
  <div>
    <p class="custom-title d-inline-block">Администраторы</p>

    <router-link to="/admins/new" class="float-end">
      <button class="btn btn-danger custom-rounded" style="margin-top: -0.75rem">Добавить администратора</button>
    </router-link>

    <div class="bg-white p-4 custom-rounded">
      <table class="table table-bordered custom-border m-0">
        <thead>
        <tr>
          <th scope="col" class="custom-title">Дата регистрации</th>
          <th scope="col" class="custom-title">Электронная почта</th>
        </tr>
        </thead>

        <tbody>
        <tr v-for="admin in this.admins">
          <th scope="row">{{ parseDate(admin.date) }}</th>
          <td>{{ admin.email }}</td>
        </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import moment from "moment";

import { index as getAdmins } from '../../lib/api/admins';

export default {
  data() {
    return {
      admins: [],
    };
  },

  methods: {
    parseDate(date) {
      return moment(date).format('DD.MM.YY');
    },
  },

  created() {
    getAdmins()
        .then(({ data }) => { this.admins = data.admins });
  },
}
</script>
