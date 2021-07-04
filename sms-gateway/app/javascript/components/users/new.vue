<template>
  <div>
    <p class="custom-title">Добавить клиента</p>

    <div class="row" style="margin: 0;">
      <div class="col-3 bg-white p-4 custom-rounded me-4">
        <p class="custom-title">Внимание!</p>
        <span>
          Заполняя имя отправителя, будьте готовы, что оно применится через неделю.
          Пока оно не применено, сообщения будут отправляться от стандартного имени, например "terasms.ru"
        </span>
      </div>

      <div class="col bg-white p-4 custom-rounded ">
        <div class="row mb-3">
          <div class="form-group col">
            <div class="input-group">
              <input type="text"
                     class="form-control"
                     v-model="requestParams.user_name"
                     placeholder="Название клиента">
            </div>
          </div>

          <div class="form-group col">
            <div class="input-group">
              <multiselect v-model="selectedProvider"
                           :options="providers"
                           track-by="id"
                           label="name"
                           :show-labels="false"
                           placeholder="Провайдер">
              </multiselect>
            </div>
          </div>
        </div>

        <div class="row mb-5">
          <div class="input-group col">
            <input type="text"
                   class="form-control"
                   v-model="requestParams.sender_name"
                   placeholder="Имя отправителя">
          </div>
        </div>

        <div class="row justify-content-end align-items-center">

          <div class="row justify-content-end align-items-center">
            <div class="col-auto text-end" v-if="!_.isEmpty(responseMessage) === true">
              <span>{{ responseMessage }}</span>
            </div>
            <div class="col-auto text-end">
              <button class="btn btn-danger custom-rounded" @click.prevent="submit">Добавить</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Multiselect from 'vue-multiselect';

import { names as getProviderNames } from '../../lib/api/providers';
import { create as createUser }      from '../../lib/api/users';

export default {
  data() {
    return {
      requestParams: {
        provider_id: null,
        user_name:   null,
        sender_name: null,
      },

      providers:       [],
      responseMessage: null,

      selectedProvider: null,
    };
  },

  components: { Multiselect },

  watch: {
    selectedProvider(provider) {
      this.requestParams.provider_id = provider.id;
    },
  },

  created() {
    getProviderNames().then(({ data }) => { this.providers = data })
  },

  methods: {
    submit() {
      createUser(this.requestParams)
          .then(() => { this.responseMessage = 'Клиент успешно добавлен' })
          .catch(error => { this.responseMessage = error.response.data.error })
    },
  },
}
</script>
