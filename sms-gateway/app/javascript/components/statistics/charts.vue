<template>
  <div>
    <div class="bg-white px-4 py-3 custom-rounded mb-4">
      <div class="row">
        <div class="col">
          <date-picker class="custom-datepicker"
                       v-model="selectedDates"
                       type="date"
                       format="DD.MM.YYYY"
                       value-type="format"
                       placeholder="Период"
                       :clearable="true"
                       range
                       range-separator=" - "/>
        </div>

        <div class="col">
          <multiselect class="custom-multiselect"
                       v-model="selectedUser"
                       :options="users"
                       track-by="id"
                       label="name"
                       :show-labels="false"
                       placeholder="Клиент">
          </multiselect>
        </div>

        <div class="col">
          <multiselect v-model="selectedProvider"
                       :options="providers"
                       track-by="id"
                       label="name"
                       :show-labels="false"
                       placeholder="Провайдер">
          </multiselect>
        </div>

        <div class="col">
          <div class="row align-items-center h-100">
            <span class="col text-end">Количество</span>
            <div class="col-auto d-flex justify-content-center form-check form-switch">
              <input class="form-check-input" type="checkbox" v-model="displayByCost">
            </div>
            <span class="col text-start">Цена</span>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-3 text-center">
          <span style="color: #a7a7a7; font-size: 12px;">По умолчанию выбран весь период работы сервиса</span>
        </div>
      </div>
    </div>

    <div class="row mb-4">
      <div class="col">
        <LineChart :chart-data="getLineChartData()" :options="chartOptions"/>
      </div>
    </div>

    <div class="row">
      <div class="col">
        <DoughnutInfo :display-by-cost="displayByCost"
                      :total-expenses="totalExpenses"
                      :total-messages="totalMessages"
                      :operators-data="operatorsData"/>
      </div>

      <div class="col">
        <DoughnutChart :chart-data="getChartsData()" :options="chartOptions"/>
      </div>
    </div>
  </div>
</template>

<script>
import DatePicker  from 'vue2-datepicker';
import Multiselect from 'vue-multiselect';

import DoughnutChart from "./charts/doughnut";
import DoughnutInfo  from "./charts/doughnut_info";
import LineChart     from "./charts/line";

import { names as getProviderNames } from '../../lib/api/providers';
import { names as getUserNames }     from '../../lib/api/users';

import {
  charts as getChartsData,
  line_chart as getLineChartData,
} from '../../lib/api/statistics';

export default {
  data: function () {
    return {
      getChartDataRequestParams: {
        date_from:   null,
        date_to:     null,
        provider_id: null,
        user_id:     null,
      },

      providers: [],
      users:     [],

      colors:        ['#0d6efd', '#6c757d', '#198754', '#dc3545', '#ffc107', '#0dcaf0', '#ffad4d'],
      costData:      [],
      displayByCost: false,
      labels:        [],
      operatorsData: [],
      quantityData:  [],
      totalExpenses: 0,
      totalMessages: 0,

      lineChartLabels: [],
      lineChartData:   [],

      selectedDates:    null,
      selectedProvider: null,
      selectedUser:     null,

      chartOptions: {
        responsive:          true,
        maintainAspectRatio: false,
        legend:              {
          labels: {
            fontColor: 'black',
            fontSize:  16
          }
        },
      },
    };
  },

  components: {
    DoughnutChart,
    DoughnutInfo,
    DatePicker,
    LineChart,
    Multiselect,
  },

  watch: {
    selectedDates: {
      deep: true,
      handler(dates) {
        this.getChartDataRequestParams.date_from = dates[0];
        this.getChartDataRequestParams.date_to   = dates[1];
        this.updateChartsData();
      },
    },

    selectedProvider(provider) {
      this.getChartDataRequestParams.provider_id = _.get(provider, 'id', null);
      this.updateChartsData();
    },

    selectedUser(user) {
      this.getChartDataRequestParams.user_id = _.get(user, 'id', null);
      this.updateChartsData();
    },
  },

  created() {
    this.updateChartsData();

    getUserNames().then(({ data }) => { this.users = data });
    getProviderNames().then(({ data }) => { this.providers = data });
  },

  methods: {
    updateChartsData() {
      getChartsData(this.getChartDataRequestParams).then(({ data }) => {
        this.labels       = data.labels;
        this.quantityData = data.quantity;
        this.costData     = data.cost;

        this.totalExpenses = _.round(data.cost.reduce((a, b) => a + b), 2);
        this.totalMessages = data.quantity.reduce((a, b) => a + b);
        this.operatorsData = [];

        data.labels.forEach((name, idx) => {
          this.operatorsData.push({
            name:     name,
            expenses: data.cost[idx],
            messages: data.quantity[idx],
          });
        });
      });

      getLineChartData(this.getChartDataRequestParams)
          .then(({ data }) => {
            this.lineChartLabels = Object.keys(data.data);
            this.lineChartData   = Object.values(data.data);
          });
    },

    getChartsData() {
      return {
        labels:   this.labels,
        datasets: [
          {
            backgroundColor: this.colors,
            data:            this.displayByCost ? this.costData : this.quantityData,
          },
        ],
      }
    },

    getLineChartData() {
      return {
        labels:   this.lineChartLabels,
        datasets: [
          {
            label:       'Количество сообщений по дням',
            fill:        false,
            borderColor: '#ff3949',
            data:        this.lineChartData,
          },
        ],
      }
    },
  },
};
</script>
