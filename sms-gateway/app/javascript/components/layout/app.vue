<template>
  <div>
    <Header class="px-4"/>
    <div class="d-flex">
      <Navbar class="px-4"/>
      <div class="p-4 w-100 custom-bg-gray">
        <router-view/>
      </div>
    </div>
  </div>
</template>

<script>
import Navbar from './navbar.vue';
import Header from './header.vue';

export default {
  components: {
    Header,
    Navbar,
  },
};
</script>
