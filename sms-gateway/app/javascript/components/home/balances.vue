<template>
  <div class="row">
    <div class="col">
      <ul class="list-group custom-rounded">
        <li class="list-group-item px-4 py-3 border-0 custom-title">
          Остаток на балансе
        </li>
        <li class="list-group-item px-4 py-3 border-top border-start-0 border-end-0 d-flex justify-content-between"
            v-for="balanceItem in this.balances">
          <small>{{ balanceItem.provider_name }}</small>
          <small>{{ balanceItem.balance }} руб.</small>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import { balances as getStatisticsInfo } from "../../lib/api/statistics";

export default {
  data() {
    return {
      balances: null,
    };
  },

  created() {
    getStatisticsInfo()
        .then(({ data }) => { this.balances = data.balances });
  },
}
</script>
