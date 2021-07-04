<template>
  <ul class="list-group custom-rounded">
    <li class="list-group-item px-4 py-3 border-0 custom-title">
      {{ displayByCost ? 'Потрачено' : 'Сообщений' }} за период:
    </li>

    <li class="list-group-item px-4 py-3 border-top border-start-0 border-end-0 d-flex justify-content-between">
      <small>Суммарно</small>
      <small>{{ displayByCost ? totalExpenses : totalMessages }}</small>
    </li>

    <li class="list-group-item px-4 py-3 border-start-0 border-end-0 d-flex justify-content-between"
        v-for="operator in operatorsData">
      <small>{{ operator.name }}</small>
      <small>{{ displayByCost ? operator.expenses : operator.messages }}</small>
    </li>
  </ul>
</template>

<script>
export default {
  props: [
    'displayByCost',
    'totalExpenses',
    'totalMessages',
    'operatorsData',
  ],
};
</script>
