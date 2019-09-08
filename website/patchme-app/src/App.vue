<template>
  <v-app>
    <v-app-bar app>
      <v-toolbar-title class="logo">
        <span>Patch Me</span>
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn text href="https://github.com/shah-gaurav/patch-me" target="_blank">
        <v-icon>mdi-github-circle</v-icon>&nbsp;
        <span class="mr-2">Souce Code</span>
      </v-btn>
      <v-btn
        text
        href="https://github.com/shah-gaurav/patch-me/blob/master/PRIVACY.md"
        target="_blank"
      >
        <span class="mr-2">Privacy Policy</span>
      </v-btn>
    </v-app-bar>

    <v-content>
      <HelloWorld />
    </v-content>

    <v-footer>
      <div class="flex-grow-1"></div>
      <div class="body-2">&copy; <a href="http://www.linkedin.com/in/gaurav-shah-boise" target="_blank">Gaurav Shah</a> - {{ new Date().getFullYear() }}</div>
      <div class="flex-grow-1"></div>
    </v-footer>
  </v-app>
</template>

<script>
import HelloWorld from './components/HelloWorld';

export default {
  name: 'App',
  components: {
    HelloWorld,
  },
  data: () => ({
    //
  }),
};
</script>

<style>
@import url("https://fonts.googleapis.com/css?family=Pacifico&display=swap");

.logo {
  font-family: "Pacifico", cursive;
  font-size: 26px;
}

</style>