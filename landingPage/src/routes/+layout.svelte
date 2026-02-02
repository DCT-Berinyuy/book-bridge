<script>
  import "../app.css";
  import { Menu, X, ArrowRight, Github } from "lucide-svelte";
  import logo from "$lib/assets/logo.png"; // Import the logo image
  import { onMount } from "svelte";

  let { children } = $props();
  let isMenuOpen = $state(false);
  let scrollY = $state(0);

  function toggleMenu() {
    isMenuOpen = !isMenuOpen;
  }
</script>

<svelte:window bind:scrollY />

<div class="app">
  <nav class:scrolled={scrollY > 20}>
    <div class="container nav-content">
      <a href="/" class="logo">
        <div class="logo-icon">
          <img src={logo} alt="BookBridge Logo" class="bookbridge-logo" />
        </div>
        <span>BookBridge</span>
      </a>

      <!-- Desktop Nav -->
      <div class="desktop-links">
        <a href="#features">Features</a>
        <a href="#how-it-works">How it Works</a>
        <a href="#showcase">Mobile App</a>
        <a
          href="https://github.com/DCT-Berinyuy/book-bridge"
          target="_blank"
          rel="noopener noreferrer"
          class="github-link"
          title="Source Code"
        >
          <Github size={20} />
        </a>
        <a
          href="https://github.com/DCT-Berinyuy/book-bridge/releases"
          target="_blank"
          rel="noopener noreferrer"
          class="btn-primary"
          style="text-decoration: none;">Download App</a
        >
      </div>

      <!-- Mobile Toggle -->
      <button class="mobile-toggle" onclick={toggleMenu}>
        {#if isMenuOpen}
          <X size={24} />
        {:else}
          <Menu size={24} />
        {/if}
      </button>
    </div>

    <!-- Mobile Menu -->
    {#if isMenuOpen}
      <div class="mobile-menu">
        <a href="#features" onclick={toggleMenu}>Features</a>
        <a href="#how-it-works" onclick={toggleMenu}>How it Works</a>
        <a href="#showcase" onclick={toggleMenu}>Mobile App</a>
        <a
          href="https://github.com/DCT-Berinyuy/book-bridge"
          target="_blank"
          rel="noopener noreferrer"
          class="github-link"
          onclick={toggleMenu}
        >
          <Github size={20} /> <span style="margin-left: 8px">GitHub</span>
        </a>
        <a
          href="https://github.com/DCT-Berinyuy/book-bridge/releases"
          target="_blank"
          rel="noopener noreferrer"
          class="btn-primary"
          style="text-decoration: none;"
          onclick={toggleMenu}>Download App</a
        >
      </div>
    {/if}
  </nav>

  <main>
    {@render children()}
  </main>

  <footer>
    <div class="container footer-content">
      <div class="footer-brand">
        <div class="logo">
          <div class="logo-icon">
            <img src={logo} alt="BookBridge Logo" class="bookbridge-logo" />
          </div>
          <span>BookBridge</span>
        </div>
        <p>
          Ending learning poverty in Cameroon through peer-to-peer book sharing.
        </p>
      </div>

      <div class="footer-links">
        <h3>Quick Links</h3>
        <a href="#features">Features</a>
        <a href="#how-it-works">About Us</a>
        <a href="#showcase">Contact</a>
      </div>

      <div class="footer-social">
        <h3>Follow Us</h3>
        <div class="social-icons">
          <a
            href="https://github.com/DCT-Berinyuy/book-bridge"
            target="_blank"
            rel="noopener noreferrer"
            title="GitHub"
          >
            <Github size={20} />
          </a>
        </div>
      </div>
    </div>
    <div class="footer-bottom">
      <p>
        &copy; {new Date().getFullYear()} BookBridge. Built by
        <a
          href="https://linktr.ee/DeepCodeThinking"
          target="_blank"
          rel="noopener noreferrer"
          style="color: var(--scholar-blue); font-weight: 600;">Mr.DCT</a
        >. All rights reserved.
      </p>
    </div>
  </footer>
</div>

<style>
  nav {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 1000;
    padding: 1.5rem 0;
    transition: all 0.3s ease;
  }

  nav.scrolled {
    background-color: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    padding: 1rem 0;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
  }

  .nav-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .github-link {
    color: var(--charcoal);
    display: flex;
    align-items: center;
    transition: color 0.3s ease;
    text-decoration: none;
    margin: 0 0.5rem;
  }

  .github-link:hover {
    color: var(--scholar-blue);
  }

  .logo {
    display: flex;
    align-items: center;
    gap: 0.8rem;
    font-size: 1.25rem;
    font-weight: 700;
    color: var(--scholar-blue);
    font-family: var(--font-header);
  }

  .bookbridge-logo {
    height: 36px; /* Adjust height as needed */
    width: auto;
    border-radius: 12px;
  }

  /* Adjustments for logo-icon when containing an image */
  .logo-icon {
    background-color: transparent; /* Remove background color */
    padding: 0; /* Remove padding */
    border-radius: 0; /* Remove border-radius */
  }

  .desktop-links {
    display: flex;
    align-items: center;
    gap: 2.5rem;
  }

  .desktop-links a {
    font-weight: 500;
    font-size: 0.95rem;
  }

  .desktop-links a:hover {
    color: var(--scholar-blue);
  }

  .mobile-toggle {
    display: none;
    background: transparent;
    color: var(--charcoal);
  }

  .mobile-menu {
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background: white;
    padding: 2rem;
    flex-direction: column;
    gap: 1.5rem;
    border-top: 1px solid #eee;
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.05);
  }

  @media (max-width: 768px) {
    .desktop-links {
      display: none;
    }
    .mobile-toggle {
      display: block;
    }
  }

  main {
    padding-top: 80px;
  }

  footer {
    background-color: #f1f3f5;
    padding: 4rem 0 2rem;
    margin-top: 4rem;
  }

  .footer-content {
    display: grid;
    grid-template-columns: 2fr 1fr 1fr;
    gap: 4rem;
    margin-bottom: 3rem;
  }

  .footer-brand p {
    margin-top: 1.5rem;
    color: var(--light-gray);
    max-width: 300px;
  }

  .footer-links {
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }

  .footer-links h3,
  .footer-social h3 {
    font-size: 1.1rem;
    margin-bottom: 0.5rem;
  }

  .footer-links a {
    color: var(--charcoal);
  }

  .social-icons {
    display: flex;
    gap: 1rem;
  }

  .footer-bottom {
    border-top: 1px solid #dee2e6;
    padding-top: 2rem;
    text-align: center;
    color: var(--light-gray);
    font-size: 0.9rem;
  }

  @media (max-width: 768px) {
    .footer-content {
      grid-template-columns: 1fr;
      gap: 2rem;
    }
  }
</style>
