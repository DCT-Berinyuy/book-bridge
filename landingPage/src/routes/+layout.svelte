<script>
  import "../app.css";
  import { Menu, X, Github, Download } from "lucide-svelte";
  import logo from "$lib/assets/logo.png";
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
  <nav class:scrolled={scrollY > 10}>
    <div class="container nav-content">
      <a href="/" class="logo">
        <div class="logo-icon">
          <img src={logo} alt="BookBridge Logo" class="bookbridge-logo" />
        </div>
        <span>BookBridge</span>
      </a>

      <!-- Desktop Nav -->
      <div class="desktop-links">
        <a href="#how-it-works">How it Works</a>
        <a href="#features">Features</a>
        <a href="#app">App</a>
        <a
          href="https://github.com/DCT-Berinyuy/book-bridge/releases"
          target="_blank"
          rel="noopener noreferrer"
          class="btn-primary"
          style="text-decoration: none; display: flex; align-items: center; gap: 8px;"
        >
          <Download size={18} /> Download App
        </a>
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
        <a href="#how-it-works" onclick={toggleMenu}>How it Works</a>
        <a href="#features" onclick={toggleMenu}>Features</a>
        <a href="#app" onclick={toggleMenu}>Mobile App</a>
        <a
          href="https://github.com/DCT-Berinyuy/book-bridge/releases"
          target="_blank"
          rel="noopener noreferrer"
          class="btn-primary"
          style="text-decoration: none; width: 100%; text-align: center;"
          onclick={toggleMenu}
        >
          Download App
        </a>
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
          Sustainable reading for every student. Join the circular economy and
          save money on education.
        </p>
        <div class="social-icons">
          <a
            href="https://github.com/DCT-Berinyuy/book-bridge"
            target="_blank"
            rel="noopener noreferrer"
            title="GitHub"
            class="social-link"
          >
            <Github size={20} />
          </a>
        </div>
      </div>

      <div class="footer-links-group">
        <div class="link-column">
          <h3>Platform</h3>
          <a href="#how-it-works">How it Works</a>
          <a href="#features">Features</a>
          <a href="#app">Download</a>
        </div>
        <div class="link-column">
          <h3>Support</h3>
          <a href="#how-it-works">Help Center</a>
          <a href="#features">Safety Guidelines</a>
          <a href="#app">Contact Us</a>
        </div>
        <div class="link-column">
          <h3>Legal</h3>
          <a href="#how-it-works">Privacy Policy</a>
          <a href="#features">Terms of Service</a>
        </div>
      </div>
    </div>

    <div class="footer-bottom">
      <div class="container">
        <p>
          &copy; {new Date().getFullYear()} BookBridge. Built with ❤️ by
          <a
            href="https://linktr.ee/DeepCodeThinking"
            target="_blank"
            rel="noopener noreferrer"
            style="color: var(--scholar-blue); font-weight: 600;">Mr.DCT</a
          >
        </p>
      </div>
    </div>
  </footer>
</div>

<style>
  .app {
    overflow-x: hidden;
    position: relative;
    width: 100%;
  }

  /* Navbar Styles */
  nav {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 1000;
    padding: 1.2rem 0;
    transition: all 0.3s ease;
    background-color: transparent;
  }

  nav.scrolled {
    background-color: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(12px);
    padding: 0.8rem 0;
    box-shadow: 0 4px 30px rgba(0, 0, 0, 0.05);
    border-bottom: 1px solid rgba(255, 255, 255, 0.3);
  }

  .nav-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .logo {
    display: flex;
    align-items: center;
    gap: 0.8rem;
    font-size: 1.3rem;
    font-weight: 700;
    color: var(--scholar-blue);
    font-family: var(--font-header);
    letter-spacing: -0.5px;
  }

  .bookbridge-logo {
    height: 32px;
    width: auto;
    border-radius: 8px;
  }

  /* Adjustments for logo-icon when containing an image */
  .logo-icon {
    background-color: transparent; /* Remove background color */
    padding: 0; /* Remove padding */
    border-radius: 0; /* Remove border-radius */
  }

  /* Desktop Nav */
  .desktop-links {
    display: flex;
    align-items: center;
    gap: 2rem;
  }

  .desktop-links a:not(.btn-primary) {
    font-weight: 500;
    font-size: 0.95rem;
    color: var(--charcoal);
    position: relative;
  }

  .desktop-links a:not(.btn-primary):hover {
    color: var(--scholar-blue);
  }

  /* Mobile Menu */
  .mobile-toggle {
    display: none;
    background: transparent;
    border: none;
    color: var(--charcoal);
    cursor: pointer;
    z-index: 1001;
  }

  .mobile-menu {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: white;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 2rem;
    padding: 2rem;
    z-index: 999;
  }

  .mobile-menu a {
    font-size: 1.25rem;
    color: var(--charcoal);
    font-weight: 600;
  }

  /* Footer Styles */
  footer {
    background-color: #f8f9fa;
    padding: 5rem 0 2rem;
    border-top: 1px solid #eef1f5;
  }

  .footer-content {
    display: grid;
    grid-template-columns: 1.5fr 2fr;
    gap: 4rem;
    margin-bottom: 4rem;
  }

  .footer-brand p {
    margin-top: 1rem;
    color: #6c757d;
    max-width: 320px;
    line-height: 1.6;
  }

  .social-icons {
    margin-top: 1.5rem;
    display: flex;
    gap: 1rem;
  }

  .social-link {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background-color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--charcoal);
    border: 1px solid #e9ecef;
    transition: all 0.3s ease;
  }

  .social-link:hover {
    background-color: var(--scholar-blue);
    color: white;
    border-color: var(--scholar-blue);
    transform: translateY(-3px);
  }

  .footer-links-group {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 2rem;
  }

  .link-column h3 {
    font-size: 1rem;
    margin-bottom: 1.5rem;
    color: var(--charcoal);
  }

  .link-column a {
    display: block;
    margin-bottom: 0.8rem;
    color: #6c757d;
    font-size: 0.95rem;
  }

  .link-column a:hover {
    color: var(--scholar-blue);
  }

  .footer-bottom {
    padding-top: 2rem;
    border-top: 1px solid #e9ecef;
    text-align: center;
    color: #adb5bd;
    font-size: 0.9rem;
  }

  @media (max-width: 768px) {
    .desktop-links {
      display: none;
    }
    .mobile-toggle {
      display: block;
    }

    .footer-content {
      grid-template-columns: 1fr;
      gap: 3rem;
    }

    .footer-links-group {
      grid-template-columns: repeat(2, 1fr);
    }
  }
</style>
