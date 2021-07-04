<template>
  <div>
    <p class="custom-title">Добавить администратора</p>

    <div class="mb-3 bg-white p-4 custom-rounded ">
      <div class="row mb-3">
        <div class="form-group col">
          <div class="input-group">
            <input type="email"
                   class="form-control"
                   v-model="requestParams.email"
                   placeholder="Email">
          </div>
        </div>
      </div>

      <div class="row mb-3">
        <div class="form-group col">
          <div class="input-group">
            <input type="password"
                   class="form-control"
                   v-model="requestParams.password"
                   placeholder="Пароль">
          </div>
        </div>

        <div class="form-group col">
          <div class="input-group">
            <input type="password"
                   class="form-control"
                   v-model="passwordConfirmation"
                   placeholder="Подтвердите пароль">
          </div>
        </div>
      </div>

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
</template>

<script>
import { create as createAdmin }      from '../../lib/api/admins';

export default {
  data() {
    return {
      requestParams: {
        email:    null,
        password: null,
      },

      passwordConfirmation: null,
      responseMessage:      null,
    };
  },

  methods: {
    submit() {
      if (this.requestParams.password !== this.passwordConfirmation) {
        this.responseMessage = 'Пароли не совпадают'
      } else {
        createAdmin(this.requestParams)
            .then(() => { this.responseMessage = 'Администратор успешно добавлен' })
            .catch(error => { this.responseMessage = error.response.data.error })
      }
    },
  },
}
</script>
