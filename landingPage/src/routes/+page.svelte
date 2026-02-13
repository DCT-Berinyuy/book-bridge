<script>
  import {
    ArrowRight,
    Search,
    ShieldCheck,
    Heart,
    Smartphone,
    CheckCircle,
    Camera,
    Upload,
    MessageCircle,
    MapPin,
    CreditCard,
    Star,
    Download,
  } from "lucide-svelte";
  import { onMount } from "svelte";
  import screenshot from "$lib/assets/screenshot.png";

  // Tab state for "How it Works"
  let activeTab = $state("buyer");

  function setTab(tab) {
    activeTab = tab;
  }
</script>

<div class="landing">
  <!-- Hero Section -->
  <section id="hero" class="hero">
    <div class="container hero-container">
      <div class="hero-content">
        <div class="badge-container">
          <span class="badge">
            <Star size={14} fill="var(--scholar-blue)" strokeWidth={0} />
            #1 Student Marketplace in Cameroon
          </span>
        </div>
        <h1>
          Buy. Sell. <br />
          <span class="highlight">Connect.</span>
        </h1>
        <p class="hero-sub">
          The easiest way for students in Yaoundé, Buea, and Douala to trade
          textbooks. Save money, reduce waste, and build your library.
        </p>

        <div class="hero-actions">
          <a
            href="https://github.com/DCT-Berinyuy/book-bridge/releases"
            target="_blank"
            rel="noopener noreferrer"
            class="btn-primary-lg"
          >
            <Download size={20} /> Download App
          </a>
          <a href="#how-it-works" class="btn-secondary-lg"> How it Works </a>
        </div>

        <div class="trust-avatars">
          <div class="avatar-group">
            <!-- Placeholders for avatars -->
            <div class="avatar" style="background-color: #e0e0e0;"></div>
            <div class="avatar" style="background-color: #d0d0d0;"></div>
            <div class="avatar" style="background-color: #c0c0c0;"></div>
            <div class="avatar" style="background-color: #b0b0b0;"></div>
          </div>
          <p>Joined by <strong>2,000+</strong> students</p>
        </div>
      </div>

      <div class="hero-image">
        <div class="phone-mockup">
          <div class="phone-screen">
            <img src={screenshot} alt="BookBridge App" class="app-screen" />
          </div>
          <div class="mockup-reflection"></div>
        </div>

        <!-- Floating Elements -->
        <div class="float-card card-1">
          <div class="icon-circle green"><CheckCircle size={16} /></div>
          <span>Book Sold!</span>
          <span class="price">+ 5,000 XAF</span>
        </div>

        <div class="float-card card-2">
          <div class="icon-circle blue"><MessageCircle size={16} /></div>
          <span>New Message</span>
          <span class="sub">Is this available?</span>
        </div>
      </div>
    </div>
  </section>

  <!-- Trust Bar -->
  <div class="trust-bar">
    <div class="container trust-content">
      <div class="trust-item">
        <h2>5k+</h2>
        <p>Books Listed</p>
      </div>
      <div class="divider"></div>
      <div class="trust-item">
        <h2>15%</h2>
        <p>Cheaper than Retail</p>
      </div>
      <div class="divider"></div>
      <div class="trust-item">
        <h2>3</h2>
        <p>Major Cities</p>
      </div>
      <div class="divider"></div>
      <div class="trust-item">
        <h2>100%</h2>
        <p>Secure</p>
      </div>
    </div>
  </div>

  <!-- How it Works Section -->
  <section id="how-it-works" class="how-it-works">
    <div class="container">
      <div class="section-header">
        <span class="section-tag">Simple Process</span>
        <h2>How BookBridge Works</h2>
        <p>Whether you're buying or selling, we make it simple and secure.</p>
      </div>

      <div class="tabs-container">
        <div class="tabs">
          <button
            class="tab-btn {activeTab === 'buyer' ? 'active' : ''}"
            onclick={() => setTab("buyer")}
          >
            I want to Buy
          </button>
          <button
            class="tab-btn {activeTab === 'seller' ? 'active' : ''}"
            onclick={() => setTab("seller")}
          >
            I want to Sell
          </button>
        </div>
      </div>

      <div class="steps-grid">
        {#if activeTab === "buyer"}
          <!-- Buyer Steps -->
          <div class="step-card">
            <div class="step-number">01</div>
            <div class="step-icon">
              <Search size={32} />
            </div>
            <h3>Discover</h3>
            <p>
              Search for the books you need by title, author, or university
              level.
            </p>
          </div>
          <div class="step-card">
            <div class="step-number">02</div>
            <div class="step-icon">
              <MessageCircle size={32} />
            </div>
            <h3>Connect</h3>
            <p>
              Chat directly with sellers to ask questions and negotiate usage.
            </p>
          </div>
          <div class="step-card">
            <div class="step-number">03</div>
            <div class="step-icon">
              <MapPin size={32} />
            </div>
            <h3>Meet Up</h3>
            <p>
              Arrange a safe meeting spot on campus to inspect and collect your
              book.
            </p>
          </div>
        {:else}
          <!-- Seller Steps -->
          <div class="step-card">
            <div class="step-number">01</div>
            <div class="step-icon">
              <Camera size={32} />
            </div>
            <h3>Snap</h3>
            <p>
              Take a few clear photos of your textbook and scan the ISBN bar
              code.
            </p>
          </div>
          <div class="step-card">
            <div class="step-number">02</div>
            <div class="step-icon">
              <Upload size={32} />
            </div>
            <h3>List</h3>
            <p>
              Set your price and condition. Your listing goes live instantly.
            </p>
          </div>
          <div class="step-card">
            <div class="step-number">03</div>
            <div class="step-icon">
              <CreditCard size={32} />
            </div>
            <h3>Earn</h3>
            <p>
              Meet the buyer, hand over the book, and get paid cash or mobile
              money.
            </p>
          </div>
        {/if}
      </div>
    </div>
  </section>

  <!-- Features Section -->
  <section id="features" class="features">
    <div class="container">
      <div class="section-header">
        <span class="section-tag">Why Us</span>
        <h2>Designed for Students</h2>
      </div>

      <div class="features-grid">
        <div class="feature-card">
          <div class="icon-box green">
            <Search size={24} color="#2ECC71" />
          </div>
          <h3>Smart Search</h3>
          <p>Filter by university, level (Level 1, Level 2...), and major.</p>
        </div>

        <div class="feature-card">
          <div class="icon-box blue">
            <Smartphone size={24} color="#1A4D8C" />
          </div>
          <h3>Lightweight App</h3>
          <p>Optimized for low data usage and works on all Android devices.</p>
        </div>

        <div class="feature-card">
          <div class="icon-box gold">
            <ShieldCheck size={24} color="#f1c40f" />
          </div>
          <h3>Verified Users</h3>
          <p>Sign up with your student email or phone number for safety.</p>
        </div>

        <div class="feature-card">
          <div class="icon-box red">
            <Heart size={24} color="#e74c3c" />
          </div>
          <h3>Community First</h3>
          <p>Rate sellers and help build a trusted network of scholars.</p>
        </div>
      </div>
    </div>
  </section>

  <!-- App Showcase / CTA -->
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
            href="https://github.com/DCT-Berinyuy/book-bridge/releases"
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
        </div>
      </div>
    </div>
  </section>
</div>

<style>
  /* Global Utilities */
  .landing {
    overflow-x: hidden;
  }

  .section-tag {
    display: inline-block;
    color: var(--scholar-blue);
    font-weight: 600;
    font-size: 0.9rem;
    padding: 0.3rem 1rem;
    background-color: rgba(26, 77, 140, 0.1);
    border-radius: 20px;
    margin-bottom: 1rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }

  .section-header {
    text-align: center;
    margin-bottom: 4rem;
  }

  .section-header h2 {
    font-size: 2.5rem;
    margin-bottom: 1rem;
    color: var(--charcoal);
  }

  .section-header p {
    color: var(--light-gray);
    font-size: 1.1rem;
    max-width: 600px;
    margin: 0 auto;
  }

  /* Hero Section */
  .hero {
    position: relative;
    padding-top: 8rem; /* Nav height + spacing */
    padding-bottom: 6rem;
    overflow: hidden;
    background: radial-gradient(
        circle at top right,
        rgba(46, 204, 113, 0.05),
        transparent 40%
      ),
      radial-gradient(
        circle at bottom left,
        rgba(26, 77, 140, 0.05),
        transparent 40%
      );
  }

  .hero-container {
    display: grid;
    grid-template-columns: 1.1fr 0.9fr;
    align-items: center;
    gap: 4rem;
  }

  .badge-container {
    margin-bottom: 1.5rem;
  }

  .badge {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.5rem 1rem;
    background-color: white;
    border: 1px solid #e0e0e0;
    border-radius: 30px;
    font-size: 0.9rem;
    font-weight: 500;
    color: var(--charcoal);
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03);
  }

  .hero h1 {
    font-size: 4.5rem;
    line-height: 1.1;
    margin-bottom: 1.5rem;
    color: var(--charcoal);
  }

  .highlight {
    color: var(--scholar-blue);
    position: relative;
    z-index: 1;
  }

  .highlight::after {
    content: "";
    position: absolute;
    bottom: 5px;
    left: 0;
    width: 100%;
    height: 15px;
    background-color: rgba(46, 204, 113, 0.2);
    z-index: -1;
    transform: skewX(-10deg);
  }

  .hero-sub {
    font-size: 1.25rem;
    color: #666;
    margin-bottom: 2.5rem;
    max-width: 500px;
    line-height: 1.6;
  }

  .hero-actions {
    display: flex;
    gap: 1rem;
    margin-bottom: 3rem;
  }

  .btn-primary-lg {
    background-color: var(--scholar-blue);
    color: white;
    padding: 1rem 2rem;
    border-radius: 12px;
    font-weight: 600;
    text-decoration: none;
    display: flex;
    align-items: center;
    gap: 0.8rem;
    font-size: 1.1rem;
    transition: all 0.3s ease;
    box-shadow: 0 10px 20px rgba(26, 77, 140, 0.2);
  }

  .btn-primary-lg:hover {
    transform: translateY(-3px);
    box-shadow: 0 15px 30px rgba(26, 77, 140, 0.3);
    background-color: #154075;
  }

  .btn-secondary-lg {
    background-color: var(--paper-white);
    color: var(--charcoal);
    padding: 1rem 2rem;
    border-radius: 12px;
    font-weight: 600;
    text-decoration: none;
    font-size: 1.1rem;
    transition: all 0.3s ease;
    border: 1px solid #ddd;
  }

  .btn-secondary-lg:hover {
    background-color: white;
    border-color: var(--scholar-blue);
    color: var(--scholar-blue);
  }

  .trust-avatars {
    display: flex;
    align-items: center;
    gap: 1rem;
  }

  .avatar-group {
    display: flex;
  }

  .avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    border: 3px solid white;
    margin-left: -15px;
  }

  .avatar:first-child {
    margin-left: 0;
  }

  /* Right Side Hero Visuals */
  .hero-image {
    position: relative;
    display: flex;
    justify-content: center;
    perspective: 1000px;
  }

  .phone-mockup {
    width: 300px;
    height: 600px;
    background: #111;
    border-radius: 40px;
    padding: 12px;
    box-shadow: 0 30px 60px rgba(0, 0, 0, 0.2);
    position: relative;
    z-index: 10;
    border: 4px solid #333;
    transform: rotateY(-10deg) rotateX(5deg);
    transition: transform 0.5s ease;
  }

  .phone-mockup:hover {
    transform: rotateY(0) rotateX(0);
  }

  .phone-screen {
    width: 100%;
    height: 100%;
    background: white;
    border-radius: 30px;
    overflow: hidden;
  }

  .app-screen {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .float-card {
    position: absolute;
    background: white;
    padding: 1rem 1.5rem;
    border-radius: 16px;
    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
    display: flex;
    align-items: center;
    gap: 1rem;
    z-index: 12;
    animation: float 6s infinite ease-in-out;
    min-width: 200px;
  }

  .card-1 {
    top: 20%;
    right: -20px;
    animation-delay: 0s;
  }

  .card-2 {
    bottom: 25%;
    left: -40px;
    animation-delay: 3s;
  }

  .icon-circle {
    width: 40px;
    height: 40px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
  }

  .icon-circle.green {
    background: var(--emerald-green);
  }
  .icon-circle.blue {
    background: var(--scholar-blue);
  }

  .float-card span {
    font-weight: 600;
    color: var(--charcoal);
  }

  .float-card .price {
    color: var(--emerald-green);
    margin-left: auto;
  }

  .float-card .sub {
    font-weight: 400;
    font-size: 0.85rem;
    color: #666;
    display: block;
  }

  @keyframes float {
    0%,
    100% {
      transform: translateY(0);
    }
    50% {
      transform: translateY(-15px);
    }
  }

  /* Trust Bar */
  .trust-bar {
    background-color: var(--scholar-blue);
    padding: 3rem 0;
    color: white;
  }

  .trust-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .trust-item {
    text-align: center;
  }

  .trust-item h2 {
    font-size: 2.5rem;
    color: white; /* Override default blue */
    margin-bottom: 0.2rem;
  }

  .trust-item p {
    font-weight: 500;
    opacity: 0.8;
  }

  .divider {
    width: 1px;
    height: 50px;
    background-color: rgba(255, 255, 255, 0.2);
  }

  /* How it Works */
  .how-it-works {
    padding: 8rem 0;
    background-color: white;
  }

  .tabs-container {
    display: flex;
    justify-content: center;
    margin-bottom: 4rem;
  }

  .tabs {
    background: #f1f3f5;
    padding: 0.5rem;
    border-radius: 100px;
    display: flex;
    gap: 0.5rem;
  }

  .tab-btn {
    padding: 0.8rem 2.5rem;
    border-radius: 100px;
    font-size: 1rem;
    font-weight: 600;
    color: #666;
    background: transparent;
    transition: all 0.3s ease;
  }

  .tab-btn.active {
    background: white;
    color: var(--scholar-blue);
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
  }

  .steps-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 3rem;
    max-width: 1100px;
    margin: 0 auto;
  }

  .step-card {
    text-align: center;
    position: relative;
    padding: 2rem;
  }

  .step-number {
    font-size: 5rem;
    font-weight: 800;
    color: #f1f3f5;
    position: absolute;
    top: 0;
    left: 50%;
    transform: translateX(-50%);
    z-index: 0;
  }

  .step-icon {
    width: 80px;
    height: 80px;
    background: white;
    border-radius: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 1.5rem;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
    position: relative;
    z-index: 1;
    color: var(--scholar-blue);
  }

  .step-card h3 {
    font-size: 1.5rem;
    margin-bottom: 1rem;
    position: relative;
    z-index: 1;
  }

  .step-card p {
    color: #666;
    position: relative;
    z-index: 1;
  }

  /* Features */
  .features {
    padding: 6rem 0 8rem;
    background-color: #f8f9fa;
  }

  .features-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 2rem;
  }

  .feature-card {
    background: white;
    padding: 2rem;
    border-radius: 20px;
    transition: all 0.3s ease;
    border-bottom: 4px solid transparent;
  }

  .feature-card:hover {
    transform: translateY(-10px);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.05);
    border-bottom-color: var(--scholar-blue);
  }

  .icon-box {
    width: 50px;
    height: 50px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 1.5rem;
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
    font-size: 1.2rem;
    margin-bottom: 0.8rem;
  }

  .feature-card p {
    font-size: 0.95rem;
    color: #666;
    line-height: 1.5;
  }

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
      transparent 100%
    );
    position: relative;
    overflow: hidden;
  }

  .showcase-box::before {
    content: "";
    position: absolute;
    width: 600px;
    height: 600px;
    background: radial-gradient(
      circle,
      rgba(255, 255, 255, 0.1) 0%,
      transparent 70%
    );
    top: -300px;
    left: -300px;
    border-radius: 50%;
  }

  .showcase-content {
    position: relative;
    z-index: 10;
    max-width: 700px;
    margin: 0 auto;
  }

  .showcase-content h2 {
    color: white;
    font-size: 3.5rem;
    margin-bottom: 1.5rem;
  }

  .showcase-content p {
    font-size: 1.25rem;
    margin-bottom: 3rem;
    opacity: 0.9;
  }

  .store-buttons {
    display: flex;
    justify-content: center;
    gap: 1.5rem;
  }

  .store-btn {
    display: flex;
    align-items: center;
    gap: 1rem;
    background: white;
    color: var(--charcoal);
    padding: 0.8rem 2rem;
    border-radius: 12px;
    text-decoration: none;
    transition: all 0.3s ease;
    border: none;
  }

  .store-btn:hover:not(:disabled) {
    transform: translateY(-5px);
    box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
  }

  .store-btn:disabled {
    opacity: 0.7;
    cursor: not-allowed;
    background: rgba(255, 255, 255, 0.2);
    color: white;
  }

  .btn-text {
    display: flex;
    flex-direction: column;
    text-align: left;
  }

  .btn-text span {
    font-size: 0.75rem;
    text-transform: uppercase;
  }

  .btn-text strong {
    font-size: 1.1rem;
  }

  /* Responsive Adjustments */
  @media (max-width: 1024px) {
    .features-grid {
      grid-template-columns: repeat(2, 1fr);
    }

    .heroh1 {
      font-size: 3.5rem;
    }
  }

  @media (max-width: 768px) {
    .hero-container {
      grid-template-columns: 1fr;
      text-align: center;
      gap: 5rem;
    }

    .badge-container {
      display: flex;
      justify-content: center;
    }

    .hero-sub {
      margin-left: auto;
      margin-right: auto;
    }

    .hero-actions {
      justify-content: center;
      flex-direction: column;
    }

    .trust-avatars {
      justify-content: center;
    }

    .hero-image {
      padding: 0 2rem;
    }

    .float-card {
      display: none; /* Hide floating cards on mobile to prevent clutter */
    }

    .trust-content {
      flex-direction: column;
      gap: 2rem;
    }

    .divider {
      width: 50%;
      height: 1px;
    }

    .steps-grid {
      grid-template-columns: 1fr;
    }

    .features-grid {
      grid-template-columns: 1fr;
    }

    .showcase-box {
      padding: 4rem 2rem;
    }

    .showcase-content h2 {
      font-size: 2.5rem;
    }

    .store-buttons {
      flex-direction: column;
    }
  }
</style>
