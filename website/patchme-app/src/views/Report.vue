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
      <v-flex class="text-md-center pt-9" xs12 md6 offset-md3>
        <v-btn class="mr-4" color="primary" @click="$refs.calendar.prev()">
          <v-icon dark>mdi-chevron-left</v-icon>Previous
        </v-btn>
        <span class="title font-weight-bold">{{ month }}</span>
        <v-btn class="ml-4" color="primary" @click="$refs.calendar.next()">
          Next
          <v-icon dark>mdi-chevron-right</v-icon>
        </v-btn>
      </v-flex>
    </v-layout>
    <v-layout v-if="records">
      <v-flex class="text-md-center pt-9" xs12 md8 offset-md2>
        <v-responsive :aspect-ratio="16/9">
          <v-calendar
            ref="calendar"
            v-model="start"
            type="month"
            :events="events"
            start="2019-09-01"
            :event-color="getEventColor"
            :event-margin-bottom="10">
            
          </v-calendar>
        </v-responsive>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import { db } from '../scripts/db'
import moment from 'moment';

export default {
  created() {
    this.start = moment().format('YYYY-MM-DD');
  },
  data() {
    return {
      recordKey: '',
      records: undefined,
      events: undefined,
      start: undefined,
    }
  },
  computed: {
    month() {
      return moment(this.start).format('MMMM YYYY');
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
        this.events = this.records.map(function (item) {
          var percentage = item['minutes'] / item['target-minutes'];
          var color = 'green';
          if (percentage < 0.5)
            color = 'red';
          else if (percentage >= 0.5 && percentage < 0.75)
            color = 'yellow';

          return { 'name': `${item['minutes']} minutes`, 'start': moment(item['date'], 'MM/DD/YYYY').format('YYYY-MM-DD'), 'color': color };
        });
      } else {
        this.records = undefined;
        alert('Record key not found. Please enter a valid record key and try again.');
      }
    },
    getEventColor(event) {
      return event.color
    },
  },
}
</script>

<style scoped>
.v-calendar .v-event {
  font-size: 30px;
}
</style>