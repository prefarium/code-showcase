<template>
  <nav>
    <ul v-if="totalPages > 1" class="pagination justify-content-center">
      <li class="page-item" :class="{disabled: currentPage <= 1}">
        <a class="page-link" @click.prevent="$emit('page', 1)">« Первая</a>
      </li>
      <li class="page-item" :class="{disabled: currentPage <= 1}">
        <a class="page-link" @click.prevent="$emit('page', currentPage-1)">‹ Пред.</a>
      </li>
      <li v-if="visibleNumbers[0] > 1" class="page-item disabled">
        <a class="page-link" href="#">…</a>
      </li>
      <li v-for="i in visibleNumbers" :key="i" class="page-item" :class="{active: currentPage === i}">
        <a class="page-link" @click.prevent="$emit('page', i)">{{i}}</a>
      </li>
      <li v-if="visibleNumbers[visibleNumbers.length -1] < totalPages" class="page-item disabled">
        <a class="page-link" href="#">…</a>
      </li>
      <li class="page-item" :class="{disabled: currentPage >= totalPages}">
        <a class="page-link" @click.prevent="$emit('page', currentPage+1)">След. ›</a>
      </li>
      <li class="page-item" :class="{disabled: currentPage >= totalPages}">
        <a class="page-link" @click.prevent="$emit('page', totalPages)">Последняя »</a>
      </li>
    </ul>
  </nav>
</template>

<script>
  export default {
    name:  'Pagination',
    props: {
      currentPage: {
        type:     Number,
        required: true,
      },
      totalPages: {
        type:     Number,
        required: true,
      },
      displayNumbers: {
        type:     Number,
        required: false,
        default:  3,
      },
    },
    emits:    ['page'],
    computed: {
      visibleNumbers() {
        const res = [];
        const max = this.currentPage + this.displayNumbers;
        for (let i = this.currentPage - this.displayNumbers; i < max; i++)
          if (i > 0 && i <= this.totalPages)
            res.push(i);

        return res;
      },
    },
  }
</script>
