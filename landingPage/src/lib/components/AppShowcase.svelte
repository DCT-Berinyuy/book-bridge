<script>
  import { Download, Smartphone, Apple } from "lucide-svelte";
  import { APP_DOWNLOAD_LINK } from "$lib/links";
</script>

<section id="app" class="app-showcase">
  <div class="container showcase-box">
    <div class="showcase-content">
      <h2>Your Library in Your Pocket</h2>
      <p>
        Download BookBridge today and join the fastest growing student
        community in Cameroon.
      </p>
      <div class="store-buttons">
        <a
          href={APP_DOWNLOAD_LINK}
          target="_blank"
          rel="noopener noreferrer"
          class="store-btn android"
        >
          <Download size={24} />
          <div class="btn-text">
            <span>Download APK</span>
            <strong>Direct Download</strong>
          </div>
        </a>
        <!-- Placeholder for Play Store -->
        <button class="store-btn other" disabled>
          <Smartphone size={24} />
          <div class="btn-text">
            <span>Coming soon to</span>
            <strong>Play Store</strong>
          </div>
        </button>
        <!-- Placeholder for App Store -->
        <button class="store-btn other" disabled>
          <Apple size={24} />
          <div class="btn-text">
            <span>Coming soon to</span>
            <strong>App Store</strong>
          </div>
        </button>
      </div>
    </div>
  </div>
</section>

<style>
  /* App Showcase */
  .app-showcase {
    padding: 2rem 0 6rem;
  }

  .showcase-box {
    background-color: var(--scholar-blue);
    border-radius: 40px;
    padding: 6rem;
    text-align: center;
    color: white;
    background-image: linear-gradient(
      135deg,
      rgba(255, 255, 255, 0.1) 0%,
      rgba(255, 255, 255, 0) 50%
    );
    box-shadow: 0 20px 40px rgba(26, 77, 140, 0.2);
  }

  .showcase-content h2 {
    font-size: 3rem;
    margin-bottom: 1.5rem;
    color: white;
  }

  .showcase-content p {
    font-size: 1.25rem;
    margin-bottom: 3rem;
    opacity: 0.9;
    max-width: 600px;
    margin-left: auto;
    margin-right: auto;
  }

  .store-buttons {
    display: flex;
    justify-content: center;
    gap: 1.5rem;
    flex-wrap: wrap;
  }

  .store-btn {
    display: flex;
    align-items: center;
    gap: 1rem;
    background: white;
    color: var(--charcoal);
    padding: 0.8rem 1.8rem;
    border-radius: 12px;
    text-decoration: none;
    transition: all 0.3s ease;
    border: none;
    min-width: 220px;
    text-align: left;
    cursor: pointer;
  }

  .store-btn:not(:disabled):hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
  }

  .store-btn.android {
    background: white;
    color: var(--scholar-blue);
  }

  .store-btn.other {
    background: rgba(255, 255, 255, 0.1);
    color: white;
    border: 1px solid rgba(255, 255, 255, 0.2);
    cursor: not-allowed;
  }

  .btn-text {
    display: flex;
    flex-direction: column;
  }

  .btn-text span {
    font-size: 0.75rem;
    text-transform: uppercase;
    letter-spacing: 1px;
    opacity: 0.8;
  }

  .btn-text strong {
    font-size: 1.1rem;
  }

  @media (max-width: 768px) {
    .showcase-box {
      padding: 4rem 2rem;
      border-radius: 30px;
    }
    .showcase-content h2 {
      font-size: 2.2rem;
    }
  }
</style>
