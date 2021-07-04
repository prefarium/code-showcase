<template>
  <div class="row">
    <div class="col">
      <ul class="list-group custom-rounded">
        <li class="list-group-item px-4 py-3 border-0 custom-title">
          Показатели
        </li>
        <li class="list-group-item px-4 py-3 border-top border-start-0 border-end-0 d-flex justify-content-between">
          <small>Систем зарегистрировано</small>
          <small>{{ _.get(info, 'users.total', null) }}</small>
        </li>
        <li class="list-group-item px-4 py-3 border-start-0 border-end-0 d-flex justify-content-between">
          <small>Всего сообщений отправлено</small>
          <small>{{ _.get(info, 'messages.total', null) }}</small>
        </li>
        <li class="list-group-item px-4 py-3 border-start-0 border-end-0 d-flex justify-content-between">
          <small>Сегодня сообщений отправлено</small>
          <small>{{ _.get(info, 'messages.today.successful', null) }}</small>
        </li>
        <li class="list-group-item px-4 py-3 border-0 d-flex justify-content-between">
          <small>Сегодня не удалось отправить</small>
          <small>{{ _.get(info, 'messages.today.with_server_error', null) }}</small>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import { info as getStatisticsInfo } from "../../lib/api/statistics";

export default {
  data() {
    return {
      info: null,
    };
  },

  created() {
    getStatisticsInfo()
        .then(({ data }) => { this.info = data });
  },
}
</script>
