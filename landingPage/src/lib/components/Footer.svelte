<script>
  import { Github, MessageCircle, Linkedin, Youtube, Instagram, Facebook } from "lucide-svelte";
  import logo from "$lib/assets/logo.png";
  import { 
    GITHUB_REPO_LINK,
    WHATSAPP_COMMUNITY_LINK,
    LINKEDIN_PROFILE_LINK,
    YOUTUBE_CHANNEL_LINK,
    INSTAGRAM_PROFILE_LINK,
    FACEBOOK_PAGE_LINK
  } from "$lib/links";
</script>

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
          href={WHATSAPP_COMMUNITY_LINK}
          target="_blank"
          rel="noopener noreferrer"
          title="WhatsApp Community"
          class="social-link"
        >
          <MessageCircle size={20} />
          <span>WhatsApp</span>
        </a>
        <a
          href={LINKEDIN_PROFILE_LINK}
          target="_blank"
          rel="noopener noreferrer"
          title="LinkedIn"
          class="social-link"
        >
          <Linkedin size={20} />
          <span>LinkedIn</span>
        </a>
        <a
          href={YOUTUBE_CHANNEL_LINK}
          target="_blank"
          rel="noopener noreferrer"
          title="YouTube"
          class="social-link"
        >
          <Youtube size={20} />
          <span>YouTube</span>
        </a>
        <a
          href={INSTAGRAM_PROFILE_LINK}
          target="_blank"
          rel="noopener noreferrer"
          title="Instagram"
          class="social-link"
        >
          <Instagram size={20} />
          <span>Instagram</span>
        </a>
        <a
          href={FACEBOOK_PAGE_LINK}
          target="_blank"
          rel="noopener noreferrer"
          title="Facebook"
          class="social-link"
        >
          <Facebook size={20} />
          <span>Facebook</span>
        </a>
        <a
          href={GITHUB_REPO_LINK}
          target="_blank"
          rel="noopener noreferrer"
          title="GitHub"
          class="social-link"
        >
          <Github size={20} />
          <span>GitHub</span>
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

<style>
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

  .footer-brand p {
    margin-top: 1rem;
    color: #6c757d;
    max-width: 320px;
    line-height: 1.6;
  }

  .social-icons {
    margin-top: 1.5rem;
    display: flex;
    flex-wrap: wrap;
    gap: 1.5rem 1rem;
  }

  .social-link {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.5rem;
    color: var(--charcoal);
    transition: all 0.3s ease;
    text-decoration: none;
    min-width: 60px;
  }

  .social-link span {
    font-size: 0.75rem;
    font-weight: 500;
    color: #6c757d;
  }

  .social-link:hover {
    color: var(--scholar-blue);
    transform: translateY(-3px);
  }

  .social-link:hover span {
    color: var(--scholar-blue);
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
    text-decoration: none;
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
    .footer-content {
      grid-template-columns: 1fr;
      gap: 3rem;
    }

    .footer-links-group {
      grid-template-columns: repeat(2, 1fr);
    }
  }

  @media (max-width: 400px) {
    .footer-content {
      gap: 2rem;
      margin-bottom: 2rem;
    }

    .footer-links-group {
      grid-template-columns: 1fr;
      gap: 1.5rem;
    }

    .footer-brand p {
      font-size: 0.9rem;
    }

    .link-column h3 {
      font-size: 0.95rem;
      margin-bottom: 1rem;
    }

    .link-column a {
      font-size: 0.85rem;
      margin-bottom: 0.6rem;
    }

    .footer-bottom {
      font-size: 0.85rem;
      padding-top: 1.5rem;
    }
  }
</style>
