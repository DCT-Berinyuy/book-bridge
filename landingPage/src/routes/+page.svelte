<script>
  import Hero from "$lib/components/Hero.svelte";
  import TrustBar from "$lib/components/TrustBar.svelte";
  import HowItWorks from "$lib/components/HowItWorks.svelte";
  import Features from "$lib/components/Features.svelte";
  import AppShowcase from "$lib/components/AppShowcase.svelte";
</script>

<div class="landing">
  <Hero />
  <TrustBar />
  <HowItWorks />
  <Features />
  <AppShowcase />
</div>

<style>
  .landing {
    overflow-x: hidden;
  }
</style>
