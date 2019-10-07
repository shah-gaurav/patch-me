<template>
  <v-container>
    <v-layout>
      <v-flex class="text-md-center" xs12 md6 offset-md3>
        <h1 class="title font-weight-bold">Patch Me: Eye Patch Tracking Report</h1>
        <p
          class="subtitle-1"
        >Enter the record key below to create the report to share with your provider</p>
      </v-flex>
    </v-layout>

    <v-form ref="form">
      <v-layout row wrap justify-center>
        <v-flex xs12 md3>
          <v-text-field label="Record Key" v-model="recordKey"></v-text-field>
        </v-flex>
      </v-layout>

      <v-layout row wrap justify-center>
        <v-flex xs12 md3>
          <v-btn block class="primary" @click="createReport" :disabled="!recordKey">Show Report</v-btn>
        </v-flex>
      </v-layout>
    </v-form>
    <v-layout v-if="records">    
      <v-flex class="text-md-center pt-9" xs12 md8 offset-md2>
        <h1 class="title font-weight-bold">Patching Report for Last 30 days</h1>  
        <pure-vue-chart
          :points="points"
          :width="800"
          :height="200"
          :show-y-axis="true"
          :show-x-axis="true"
          :show-values="true"
          :show-trend-line="true"
          :trend-line-width="2"
          trend-line-color="lightblue"
        />
      </v-flex>
    </v-layout>
    <v-layout v-if="records">    
      <v-flex class="text-md-center pt-9" xs12 md8 offset-md2>
        <h2 class="title">Average Minutes Patched per Day (Only on Days Patched): {{averageTimePatchedPerDay}}</h2> 
        <h2 class="title">Average Minutes Patched per Day (All 30 days): {{averageTimePatchedPerDayOver30Days}}</h2>         
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import { db } from '../scripts/db'
import moment from 'moment';
import PureVueChart from 'pure-vue-chart';

export default {
  components: {
    PureVueChart,
  },
  data() {
    return {
      recordKey: '8430-1313-6812-0105',
      points: [],
      numberOfDaysPatched: 0,
      averageTimePatchedPerDay: undefined,
      averageTimePatchedPerDayOver30Days: undefined,
      records: undefined,
    }
  },
  methods: {
    createReport: async function () {
      var documentSnapshot = await db.collection('users')
        .doc(this.recordKey)
        .get();
      if (documentSnapshot.exists) {
        var document = documentSnapshot.data();
        this.records = document.data;        
        this.points.length = 0;
        this.numberOfDaysPatched = 0;
        var totalPatchTime = 0;
         for(var i = 30; i > 0; i--){
          var date = moment().subtract(i, 'days').format('M/D/YYYY');
          var record = this.records.find(v => v['date'] === date);
          if(record) {
            totalPatchTime += record['minutes'];
            this.points.push(record['minutes']);
            this.numberOfDaysPatched++;
          } else {
            this.points.push(0);
          }
        }
        this.averageTimePatchedPerDay = Math.floor(totalPatchTime / this.numberOfDaysPatched);
        this.averageTimePatchedPerDayOver30Days = Math.floor(totalPatchTime / 30);        
      } else {
        this.records = undefined;
        alert('Record key not found. Please enter a valid record key and try again.');
      }
    },
  },
}
</script>

<style scoped>
.v-calendar .v-event {
  font-size: 30px;
}
</style>