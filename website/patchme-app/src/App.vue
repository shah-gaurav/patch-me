<template>
  <v-app>
    <v-app-bar app>
      <v-toolbar-title style="font-family: 'Pacifico', cursive; font-size: 26px;">
        <router-link to="/" style="text-decoration: none; color: black;">
          <span>Patch Me</span>
        </router-link>
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <v-toolbar-items class="d-none d-sm-flex">
        <v-btn text to="/">
          <home-icon />&nbsp;
          <span class="mr-2">Home</span>
        </v-btn>
        <v-btn text to="/report">
          <file-document-box />&nbsp;
          <span class="mr-2">Report</span>
        </v-btn>
        <v-btn text href="https://github.com/shah-gaurav/patch-me" target="_blank">
          <github-circle />&nbsp;
          <span class="mr-2">Souce Code</span>
        </v-btn>
      </v-toolbar-items>
      <v-menu bottom left>
        <template v-slot:activator="{ on }">
          <v-btn icon color="black" v-on="on" class="d-flex d-sm-none">
            <menu-icon />
          </v-btn>
        </template>

        <v-list>
          <v-list-item>
            <v-list-item-title>
              <v-btn text to="/">
                <v-icon>mdi-home</v-icon>&nbsp;
                <span class="mr-2">Home</span>
              </v-btn>
            </v-list-item-title>
          </v-list-item>
          <v-list-item>
            <v-list-item-title>
              <v-btn text to="/report">
                <v-icon>mdi-file-document-box</v-icon>&nbsp;
                <span class="mr-2">Report</span>
              </v-btn>
            </v-list-item-title>
          </v-list-item>
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
      <router-view />
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
import HomeIcon from 'vue-material-design-icons/Home.vue';
import FileDocumentBox from 'vue-material-design-icons/FileDocumentBox.vue';
import GithubCircle from 'vue-material-design-icons/GithubCircle.vue';
import MenuIcon from 'vue-material-design-icons/Menu.vue';

export default {
  components: {
    HomeIcon,
    FileDocumentBox,
    GithubCircle,
    MenuIcon
  }
};
</script>
