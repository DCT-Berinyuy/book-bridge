<script>
  import {
    ArrowRight,
    Search,
    ShieldCheck,
    Heart,
    Smartphone,
  } from "lucide-svelte";
  import { onMount } from "svelte";
  import screenshot from "$lib/assets/screenshot.png";

  // Micro-animations logic could go here
</script>

<div class="landing">
  <!-- Hero Section -->
  <section id="showcase" class="hero">
    <div class="container hero-content">
      <div class="hero-text">
        <span class="badge">Marketplace for Students</span>
        <h1>Bridging the Gap to <span>Affordable</span> Education</h1>
        <p>
          Buy, sell, and exchange physical textbooks with other students in
          Cameroon. Save money and help end learning poverty together.
        </p>

        <div class="hero-actions">
          <a
            href="#features"
            class="btn-primary"
            style="text-decoration: none; display: flex; align-items: center;"
          >
            Browse Books <ArrowRight size={18} style="margin-left: 8px" />
          </a>
          <a
            href="#features"
            class="btn-secondary"
            style="text-decoration: none;">Learn More</a
          >
        </div>

        <div class="stats">
          <div class="stat-item">
            <strong>5k+</strong>
            <span>Books Listed</span>
          </div>
          <div class="stat-item">
            <strong>2k+</strong>
            <span>Students Joined</span>
          </div>
          <div class="stat-item">
            <strong>15%</strong>
            <span>Commission</span>
          </div>
        </div>
      </div>

      <div class="hero-visual">
        <div class="mockup-container">
          <!-- Main App Mockup Placeholder -->
          <div class="phone-mockup">
            <div class="phone-screen">
              <img
                src={screenshot}
                alt="BookBridge App Preview"
                class="screenshot-img"
              />
            </div>
          </div>
          <div class="blob"></div>
        </div>
      </div>
    </div>
  </section>

  <!-- Features Section -->
  <section id="features" class="features">
    <div
      id="how-it-works"
      style="position: absolute; transform: translateY(-100px);"
    ></div>
    <div class="container">
      <div class="section-header">
        <h2>Built for the <span>Cameroonian</span> Student</h2>
        <p>
          Experience a marketplace designed around your academic needs and local
          constraints.
        </p>
      </div>

      <div class="features-grid">
        <div class="feature-card">
          <div class="icon-box green">
            <Search size={24} color="#2ECC71" />
          </div>
          <h3>Easy Search</h3>
          <p>
            Find books by title, author, or university level. Filtering designed
            for local programs.
          </p>
        </div>

        <div class="feature-card">
          <div class="icon-box blue">
            <Smartphone size={24} color="#1A4D8C" />
          </div>
          <h3>Mobile First</h3>
          <p>
            Access the marketplace anywhere. Low data usage and lightning fast
            performance.
          </p>
        </div>

        <div class="feature-card">
          <div class="icon-box gold">
            <ShieldCheck size={24} color="#f1c40f" />
          </div>
          <h3>Secure Exchange</h3>
          <p>
            Direct student-to-student transactions with verified WhatsApp
            contact points.
          </p>
        </div>

        <div class="feature-card">
          <div class="icon-box red">
            <Heart size={24} color="#e74c3c" />
          </div>
          <h3>Social Impact</h3>
          <p>
            Supporting sustainable education by keeping textbooks in circulation
            longer.
          </p>
        </div>
      </div>
    </div>
  </section>

  <!-- CTA Section -->
  <section class="cta">
    <div class="container cta-box">
      <div class="cta-content">
        <h2>Ready to start saving?</h2>
        <p>
          Join thousands of students across Yaoundé, Buea, and Douala today.
        </p>
        <a
          href="https://github.com/DCT-Berinyuy/book-bridge/releases"
          target="_blank"
          rel="noopener noreferrer"
          class="btn-primary"
          style="background-color: white; color: var(--scholar-blue); text-decoration: none; display: inline-block;"
        >
          Download for Android
        </a>
      </div>
    </div>
  </section>
</div>

<style>
  .landing {
    padding-bottom: 4rem;
  }

  section {
    padding: 6rem 0;
  }

  /* Hero Styles */
  .hero {
    background: linear-gradient(135deg, #f8f9fa 0%, #eef1f5 100%);
    overflow: hidden;
    padding-top: 4rem;
  }

  .hero-content {
    display: grid;
    grid-template-columns: 1.2fr 0.8fr;
    gap: 4rem;
    align-items: center;
  }

  .badge {
    display: inline-block;
    padding: 6px 16px;
    background-color: rgba(26, 77, 140, 0.1);
    color: var(--scholar-blue);
    border-radius: 20px;
    font-weight: 600;
    font-size: 0.85rem;
    margin-bottom: 2rem;
  }

  .hero-text h1 {
    font-size: 4rem;
    line-height: 1.1;
    margin-bottom: 1.5rem;
  }

  .hero-text h1 span {
    color: var(--emerald-green);
  }

  .hero-text p {
    font-size: 1.2rem;
    color: var(--charcoal);
    margin-bottom: 2.5rem;
    max-width: 550px;
    opacity: 0.8;
  }

  .hero-actions {
    display: flex;
    gap: 1.5rem;
    margin-bottom: 4rem;
  }

  .stats {
    display: flex;
    gap: 3rem;
  }

  .stat-item strong {
    display: block;
    font-size: 1.8rem;
    color: var(--scholar-blue);
  }

  .stat-item span {
    font-size: 0.9rem;
    color: var(--light-gray);
  }

  .hero-visual {
    position: relative;
    display: flex;
    justify-content: center;
  }

  /* Simple Phone CSS Mockup */
  .phone-mockup {
    width: 280px;
    height: 560px;
    background: #000;
    border-radius: 40px;
    padding: 12px;
    box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
    z-index: 2;
    position: relative;
  }

  .phone-screen {
    width: 100%;
    height: 100%;
    background: white;
    border-radius: 30px;
    overflow: hidden;
    position: relative;
    display: flex;
    flex-direction: column;
  }

  .screenshot-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .blob {
    position: absolute;
    width: 400px;
    height: 400px;
    background: var(--scholar-blue);
    opacity: 0.05;
    border-radius: 30% 70% 70% 30% / 30% 30% 70% 70%;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    animation: blobify 20s infinite alternate;
  }

  @keyframes blobify {
    0% {
      border-radius: 30% 70% 70% 30% / 30% 30% 70% 70%;
    }
    100% {
      border-radius: 60% 40% 30% 70% / 60% 30% 70% 40%;
    }
  }

  /* Features Styles */
  .section-header {
    text-align: center;
    margin-bottom: 5rem;
  }

  .section-header h2 {
    font-size: 2.5rem;
    margin-bottom: 1.5rem;
  }

  .section-header h2 span {
    color: var(--emerald-green);
  }

  .section-header p {
    color: var(--light-gray);
    font-size: 1.1rem;
    max-width: 600px;
    margin: 0 auto;
  }

  .features-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 2.5rem;
  }

  .feature-card {
    background: white;
    padding: 2.5rem;
    border-radius: 20px;
    transition: all 0.3s ease;
    border: 1px solid #f1f3f5;
  }

  .feature-card:hover {
    transform: translateY(-10px);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.05);
    border-color: var(--scholar-blue);
  }

  .icon-box {
    width: 56px;
    height: 56px;
    border-radius: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 2rem;
  }

  .icon-box.green {
    background: rgba(46, 204, 113, 0.1);
  }
  .icon-box.blue {
    background: rgba(26, 77, 140, 0.1);
  }
  .icon-box.gold {
    background: rgba(241, 196, 15, 0.1);
  }
  .icon-box.red {
    background: rgba(231, 76, 60, 0.1);
  }

  .feature-card h3 {
    font-size: 1.25rem;
    margin-bottom: 1rem;
  }

  .feature-card p {
    font-size: 0.95rem;
    color: var(--light-gray);
  }

  /* CTA Styles */
  .cta-box {
    background-color: var(--scholar-blue);
    border-radius: 30px;
    padding: 6rem;
    color: white;
    text-align: center;
  }

  .cta-box h2 {
    color: white;
    font-size: 3rem;
    margin-bottom: 1rem;
  }

  .cta-box p {
    font-size: 1.25rem;
    margin-bottom: 3rem;
    opacity: 0.9;
  }

  @media (max-width: 1024px) {
    .features-grid {
      grid-template-columns: repeat(2, 1fr);
    }
    .hero-text h1 {
      font-size: 3rem;
    }
  }

  @media (max-width: 768px) {
    .hero-content {
      grid-template-columns: 1fr;
      text-align: center;
    }
    .hero-text p {
      margin-left: auto;
      margin-right: auto;
    }
    .hero-actions {
      justify-content: center;
    }
    .stats {
      justify-content: center;
    }
    .hero-visual {
      margin-top: 4rem;
    }
    .hero-text h1 {
      font-size: 2.5rem;
    }
    .hero-text p {
      font-size: 1.1rem;
    }
    .cta-box {
      padding: 4rem 2rem;
    }
    .features-grid {
      grid-template-columns: 1fr;
    }
  }
</style>
