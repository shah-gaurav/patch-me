<template>
  <v-container>
    <v-layout
      text-center
      wrap
    >
      <v-flex xs12>
        <v-img
          :src="require('../assets/patch-me-logo.png')"
          class="my-3"
          contain
          height="200"
        ></v-img>
      </v-flex>

      <v-flex mb-4>
        <h1 class="font-weight-bold mb-3 title">
          Patch Me: Eye Patch Tracking
        </h1>
        <p class="font-weight-regular body-1">
          Patch Me is an Open Source FREE App that allows parents to track the eye patching time for their children
          </p>
          <p class="font-weight-bold body-1">
          Dedicated to my brave and beautiful daughter Aamani</p>      
      </v-flex>

    </v-layout>
  </v-container>
</template>

<script>
export default {
  data: () => ({
  }),
};
</script>
