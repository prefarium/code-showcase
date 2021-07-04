<template>
  <div>
    <p class="custom-title">Отправить сообщение</p>

    <div class="bg-white p-4 custom-rounded mb-3">
      <div class="row mb-3">
        <div class="form-group col">
          <div class="input-group">
            <multiselect v-model="selectedUser"
                         :options="users"
                         track-by="id"
                         label="name"
                         :show-labels="false"
                         placeholder="Выберите отправителя"/>
          </div>
        </div>
      </div>

      <div class="row mb-3">
        <div class="input-group col">
          <input class="form-control"
                 type="text"
                 placeholder="Получатель, например 78005553535"
                 v-model="inputTarget">
        </div>
      </div>

      <div class="row">
        <div class="input-group col">
            <textarea class="form-control"
                      placeholder="Сообщение"
                      v-model="inputContent"/>
        </div>
      </div>
    </div>

    <div class="row justify-content-end align-items-center">
      <div class="col-auto text-end" v-if="!_.isEmpty(responseMessage) === true">
        <span>{{ responseMessage }}</span>
      </div>
      <div class="col-auto text-end">
        <button class="btn btn-danger custom-rounded" @click.prevent="submit">Отправить</button>
      </div>
    </div>
  </div>
</template>

<script>
import Multiselect from 'vue-multiselect';

import { names as getUserNames } from '../../lib/api/users';
import { create as sendMessage } from '../../lib/api/messages';

export default {
  data() {
    return {
      requestParams: {
        user_id: null,
        target:  null,
        content: null,
      },

      responseMessage: null,

      users:        [],
      selectedUser: null,
      inputTarget:  null,
      inputContent: null,
    };
  },

  components: {
    Multiselect,
  },

  watch: {
    selectedUser(user) {
      this.requestParams.user_id = _.get(user, 'id', null);
    },

    inputTarget(target) {
      this.requestParams.target = target;
    },

    inputContent(content) {
      this.requestParams.content = content;
    },
  },

  created() {
    getUserNames().then(({ data }) => { this.users = data });
  },

  methods: {
    submit() {
      sendMessage(this.requestParams)
          .then(() => { this.responseMessage = 'Сообщение отправлено!' })
          .catch(error => { this.responseMessage = error.response.data.error })
    },
  },
}
</script>
