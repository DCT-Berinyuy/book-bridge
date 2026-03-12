<script>
  import { Menu, X, Github, Download } from "lucide-svelte";
  import logo from "$lib/assets/logo.png";
  import { APP_DOWNLOAD_LINK, GITHUB_REPO_LINK } from "$lib/links";

  let { scrollY = 0 } = $props();
  let isMenuOpen = $state(false);

  function toggleMenu() {
    isMenuOpen = !isMenuOpen;
  }
</script>

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
        href={GITHUB_REPO_LINK}
        target="_blank"
        rel="noopener noreferrer"
        title="GitHub"
        class="social-link nav-github"
      >
        <Github size={20} />
      </a>
      <a
        href={APP_DOWNLOAD_LINK}
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
        href={GITHUB_REPO_LINK}
        target="_blank"
        rel="noopener noreferrer"
        onclick={toggleMenu}
        style="display: flex; align-items: center; gap: 8px;"
      >
        <Github size={24} /> GitHub
      </a>
      <a
        href={APP_DOWNLOAD_LINK}
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

<style>
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
    text-decoration: none;
  }

  .bookbridge-logo {
    height: 32px;
    width: auto;
    border-radius: 8px;
  }

  .logo-icon {
    background-color: transparent;
    padding: 0;
    border-radius: 0;
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
    text-decoration: none;
  }

  .desktop-links a:not(.btn-primary):hover {
    color: var(--scholar-blue);
  }

  /* Mobile Menu Toggle */
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
    text-decoration: none;
  }

  .social-link {
    display: flex;
    align-items: center;
    color: var(--charcoal);
    transition: all 0.3s ease;
    text-decoration: none;
  }

  .social-link:hover {
    color: var(--scholar-blue);
    transform: translateY(-3px);
  }

  @media (max-width: 768px) {
    .desktop-links {
      display: none;
    }
    .mobile-toggle {
      display: block;
    }
  }

  @media (max-width: 400px) {
    nav {
      padding: 0.8rem 0;
    }

    .logo {
      font-size: 1.1rem;
    }

    .bookbridge-logo {
      height: 28px;
    }
  }
</style>
