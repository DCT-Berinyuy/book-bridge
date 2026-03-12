<script>
  import { Search, Smartphone, ShieldCheck, Heart } from "lucide-svelte";
</script>

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

<style>
  /* Features */
  .features {
    padding: 6rem 0 8rem;
    background-color: #f8f9fa;
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

  @media (max-width: 1024px) {
    .features-grid {
      grid-template-columns: repeat(2, 1fr);
    }
  }

  @media (max-width: 480px) {
    .features-grid {
      grid-template-columns: 1fr;
    }
    .features {
      padding: 4rem 0;
    }
  }
</style>
