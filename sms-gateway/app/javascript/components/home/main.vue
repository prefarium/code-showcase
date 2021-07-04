<template>
  <div>
    <p class="custom-title">Главная</p>

    <div class="row">
      <div class="col">
        <Info/>
      </div>

      <div class="col">
        <Balances/>
      </div>
    </div>
  </div>
</template>

<script>
import Info     from "./info";
import Balances from "./balances";

export default {
  components: {
    Info,
    Balances,
  },
};
</script>
