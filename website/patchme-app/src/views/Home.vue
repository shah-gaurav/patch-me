<template>
  <v-container>
    <v-row>
      <v-col class="text-center">
        <v-img :src="require('../assets/patch-me-logo.png')" class="my-3" contain height="200"></v-img>

        <h1 class="font-weight-bold mb-3 title">Patch Me: Eye Patch Tracking</h1>
        <p
          class="font-weight-regular body-1"
        >Patch Me is an Open Source FREE App that allows parents to track the eye patching time for their children</p>
        <a
          href="https://play.google.com/store/apps/details?id=com.edocllc.patch_me&pcampaignid=MKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1"
        >
          <img
            alt="Get it on Google Play"
            src="https://play.google.com/intl/en_us/badges/images/generic/en_badge_web_generic.png"
            style="height:60px;"
          />
        </a>
        <a
          href="https://apps.apple.com/us/app/patch-me-eye-patch-tracking/id1479306625?mt=8"
          style="margin:10px;display:inline-block;overflow:hidden;background:url(https://linkmaker.itunes.apple.com/en-us/badge-lrg.svg?releaseDate=2019-09-11&kind=iossoftware&bubble=ios_apps) no-repeat;width:135px;height:40px;"
        ></a>
      </v-col>
    </v-row>
    <v-row>
      <v-col class="text-center">
        <p class="font-weight-bold body-1">Dedicated to my brave and beautiful daughter Aamani</p>
        <v-flex hidden-md-and-up>
          <div class="embed-container">
            <iframe
              src="https://www.youtube.com/embed//qnofZc6Pn3Y"
              frameborder="0"
              allowfullscreen
            ></iframe>
          </div>
        </v-flex>
        <v-flex hidden-sm-and-down>
          <iframe
            width="560"
            height="315"
            src="https://www.youtube.com/embed/qnofZc6Pn3Y"
            frameborder="0"
            allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
            allowfullscreen
          ></iframe>
        </v-flex>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>

export default {
  name: 'home',
}
</script>

<style scoped>
.embed-container {
  position: relative;
  padding-bottom: 56.25%;
  height: 0;
  overflow: hidden;
  max-width: 100%;
}
.embed-container iframe,
.embed-container object,
.embed-container embed {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}
</style>