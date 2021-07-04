<template>
  <nav class="col-auto">
    <ul class="list-group no-decoration no-px-for-li">
      <li class="list-group-item border-0"
          :class="{ 'svg-red': currentPath === '' }"
          @click="updateCurrentPath()">
        <router-link to="/" class="d-flex align-items-center gap-3">
          <HomeIcon class="px-6"/>
          <span>Главная</span>
        </router-link>
      </li>
      <li class="list-group-item border-0"
          :class="{ 'svg-red': _.includes(currentPath, 'statistics') }"
          @click="updateCurrentPath()">
        <router-link to="/statistics" class="d-flex align-items-center gap-3">
          <StatisticsIcon class="px-6"/>
          <span>Статистика</span>
        </router-link>
      </li>
      <li class="list-group-item border-0"
          :class="{ 'svg-red': _.includes(currentPath, 'messages/index') }"
          @click="updateCurrentPath()">
        <router-link to="/messages/index" class="d-flex align-items-center gap-3">
          <MessageHistoryIcon class="px-6"/>
          <span>Журнал сообщений</span>
        </router-link>
      </li>
      <li class="d-flex align-items-center list-group-item gap-3 border-0"
          :class="{ 'svg-red': _.includes(currentPath, 'messages/new') }"
          @click="updateCurrentPath()">
        <router-link to="/messages/new" class="d-flex align-items-center gap-3">
          <MessageSendingIcon class="px-6"/>
          <span>Отправить сообщение</span>
        </router-link>
      </li>
      <li class="d-flex align-items-center list-group-item gap-3 border-0"
          :class="{ 'svg-red': _.includes(currentPath, 'users') }"
          @click="updateCurrentPath()">
        <router-link to="/users/index" class="d-flex align-items-center gap-3">
          <UserIcon class="px-6"/>
          <span>Клиенты системы</span>
        </router-link>
      </li>
      <li class="d-flex align-items-center list-group-item gap-3 border-0"
          :class="{ 'svg-red': _.includes(currentPath, 'providers') }"
          @click="updateCurrentPath()">
        <router-link to="/providers/index" class="d-flex align-items-center gap-3">
          <ProviderIcon class="px-6"/>
          <span>Провайдеры</span>
        </router-link>
      </li>
      <li class="d-flex align-items-center list-group-item gap-3 border-0"
          :class="{ 'svg-red': _.includes(currentPath, 'admins') }"
          @click="updateCurrentPath()">
        <router-link to="/admins/index" class="d-flex align-items-center gap-3">
          <AdminIcon class="px-6"/>
          <span>Администраторы</span>
        </router-link>
      </li>
    </ul>
  </nav>
</template>

<script>
import AdminIcon          from '../../icons/navbar/admin'
import HomeIcon           from '../../icons/navbar/home'
import MessageHistoryIcon from '../../icons/navbar/message_history'
import MessageSendingIcon from '../../icons/navbar/message_sending'
import ProviderIcon       from '../../icons/navbar/provider'
import StatisticsIcon     from '../../icons/navbar/statistics'
import UserIcon           from '../../icons/navbar/user'

export default {
  data() {
    return {
      currentPath: null,
    };
  },

  components: {
    AdminIcon,
    HomeIcon,
    MessageHistoryIcon,
    MessageSendingIcon,
    ProviderIcon,
    StatisticsIcon,
    UserIcon,
  },

  methods: {
    updateCurrentPath() {
      console.log(this.$router.currentRoute.path);
      this.currentPath = this.$router.currentRoute.path;
    }
  },
}
</script>

<style lang="scss">
.svg-red {
  svg {
    circle, path {
      stroke: red;
      fill: none;
    }
  }
}

li:hover {
  @extend .svg-red;
}
</style>
