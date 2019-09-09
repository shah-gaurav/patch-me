<template>
  <v-app>
    <v-app-bar app>
      <v-toolbar-title class="logo">
        <span>Patch Me</span>
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <v-toolbar-items class="d-none d-sm-flex">
        <!-- <v-btn
          text
          href="https://github.com/shah-gaurav/patch-me/blob/master/PRIVACY.md"
          target="_blank"
        >
          <v-icon>mdi-file-document-box</v-icon>&nbsp;
          <span class="mr-2">Report</span>
        </v-btn> -->
        <v-btn text href="https://github.com/shah-gaurav/patch-me" target="_blank">
          <v-icon>mdi-github-circle</v-icon>&nbsp;
          <span class="mr-2">Souce Code</span>
        </v-btn>
      </v-toolbar-items>
      <v-menu bottom left>
        <template v-slot:activator="{ on }">
          <v-btn icon color="black" v-on="on" class="d-flex d-sm-none">
            <v-app-bar-nav-icon></v-app-bar-nav-icon>
          </v-btn>
        </template>

        <v-list>
          <!-- <v-list-item>
            <v-list-item-title>
              <v-btn
                text
                href="https://github.com/shah-gaurav/patch-me/blob/master/PRIVACY.md"
                target="_blank"
              >
                <v-icon>mdi-file-document-box</v-icon>&nbsp;
                <span class="mr-2">Report</span>
              </v-btn>
            </v-list-item-title>
          </v-list-item> -->
          <v-list-item>
            <v-list-item-title>
              <v-btn text href="https://github.com/shah-gaurav/patch-me" target="_blank">
                <v-icon>mdi-github-circle</v-icon>&nbsp;
                <span class="mr-2">Souce Code</span>
              </v-btn>
            </v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-app-bar>

    <v-content>
      <HelloWorld />
    </v-content>

    <v-footer>
      <div class="flex-grow-1"></div>
      <div class="body-2">
        &copy;
        <a href="http://www.linkedin.com/in/gaurav-shah-boise" target="_blank">Gaurav Shah</a>
        - {{ new Date().getFullYear() }}
      </div>
      <div class="body-2 pl-2">|</div>
      <div class="body-2 pl-2">
        <a href="https://github.com/shah-gaurav/patch-me/blob/master/PRIVACY.md" target="_blank">
          <span class="mr-2">Privacy Policy</span>
        </a>
      </div>
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