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
          <v-text-field label="Record Key"></v-text-field>
        </v-flex>
      </v-layout>

      <v-layout row wrap justify-center>
        <v-flex xs12 md3>
          <v-btn block class="primary">Create Report</v-btn>
        </v-flex>
      </v-layout>
    </v-form>
  </v-container>
</template>

<script>
/*import { db } from '../scripts/db'
 db.collection('users')
  .doc('4415-3824-7818-2370')
  .get()
  .then(snapshot => {
    const document = snapshot.data()
    // do something with document
    alert(document.data[0].date)
  }); */
export default {

}


</script>