/* ---------------- HAMBURGER MENU TOGGLE ---------------- */

function initHamburgerMenu() {
  // Prevent double-initialization
  if (window.__hamburgerInitialized) {
    console.log('initHamburgerMenu() skipped — already initialized');
    return;
  }
  console.log('initHamburgerMenu() called');
  
  const hamburger = document.getElementById('hamburger');
  const navMenu = document.getElementById('nav-menu');
  const menuOverlay = document.getElementById('menu-overlay');

  console.log('Elements found:', {
    hamburger: !!hamburger,
    navMenu: !!navMenu,
    menuOverlay: !!menuOverlay
  });

  if (!hamburger || !navMenu || !menuOverlay) {
    console.error('❌ ERROR: Missing required elements!');
    console.error('hamburger:', hamburger);
    console.error('navMenu:', navMenu);
    console.error('menuOverlay:', menuOverlay);
    return;
  }

  console.log('✓ All elements found');

  function closeMenu() {
    console.log('→ Closing menu');
    hamburger.classList.remove('active');
    navMenu.classList.remove('active');
    menuOverlay.classList.remove('active');
  }

  function openMenu() {
    console.log('→ Opening menu');
    hamburger.classList.add('active');
    navMenu.classList.add('active');
    menuOverlay.classList.add('active');
  }

  // Hamburger button - toggle menu
  hamburger.addEventListener('click', function(e) {
    e.preventDefault();
    e.stopPropagation();
    console.log('HAMBURGER CLICKED!');
    
    if (navMenu.classList.contains('active')) {
      closeMenu();
    } else {
      openMenu();
    }
  });

  // Close menu when clicking overlay
  menuOverlay.addEventListener('click', function(e) {
    console.log('OVERLAY CLICKED!');
    e.stopPropagation();
    closeMenu();
  });

  // Close menu when clicking nav links
  const navLinks = navMenu.querySelectorAll('a');
  console.log('Found ' + navLinks.length + ' nav links');
  
  navLinks.forEach(function(link) {
    link.addEventListener('click', function(e) {
      console.log('NAV LINK CLICKED:', link.textContent);
      e.stopPropagation();
      closeMenu();
    });
  });

  // Prevent menu clicks from closing menu
  navMenu.addEventListener('click', function(e) {
    e.stopPropagation();
  });

  console.log('✓ All event listeners attached');
  // mark initialized
  window.__hamburgerInitialized = true;
}

// Try to initialize immediately
if (document.readyState === 'loading') {
  console.log('DOM still loading, waiting for DOMContentLoaded');
  document.addEventListener('DOMContentLoaded', initHamburgerMenu);
} else {
  console.log('DOM already loaded, initializing immediately');
  initHamburgerMenu();
}

// No window.load re-init — guarded by DOMContentLoaded/init checks above


/* ---------------- LOAD CONTENT FROM JSON ---------------- */

let contentData = {};

async function loadContent() {
  console.log('loadContent() STARTED');
  try {
    console.log('Fetching content.json...');
    const response = await fetch('content.json');
    console.log('Response received:', response.status);
    contentData = await response.json();
    console.log('Content loaded successfully:', contentData);
    console.log('Services:', contentData.services);
    console.log('Service items:', contentData.services.items);
    console.log('Calling populateContent...');
    populateContent();
    console.log('populateContent completed');
    
    // Initialize premium services section after content is loaded
    setTimeout(() => {
      initPremiumServicesSection();
    }, 100);
  } catch (error) {
    console.error('ERROR in loadContent():', error);
    console.error('Error message:', error.message);
    console.error('Error stack:', error.stack);
  }
}

function populateContent() {
  console.log('populateContent() called!');
  // Populate Hero Section
  if (contentData.hero) {
    const heroTitle = document.getElementById(contentData.hero.titleId);
    const heroDesc = document.getElementById(contentData.hero.descriptionId);
    const heroBtnPrimary = document.getElementById(contentData.hero.primaryBtnId);
    const heroBtnSecondary = document.getElementById(contentData.hero.secondaryBtnId);
    
    if (heroTitle) heroTitle.textContent = contentData.hero.title;
    if (heroDesc) heroDesc.textContent = contentData.hero.description;
    if (heroBtnPrimary) heroBtnPrimary.textContent = contentData.hero.primaryBtnText;
    if (heroBtnSecondary) heroBtnSecondary.textContent = contentData.hero.secondaryBtnText;
  }

  // Populate Intro Section
  if (contentData.intro) {
    const introTitle = document.getElementById(contentData.intro.titleId);
    const introDesc = document.getElementById(contentData.intro.descriptionId);
    const introBtn = document.getElementById(contentData.intro.btnId);
    
    if (introTitle) introTitle.innerHTML = contentData.intro.title.replace(/&/g, '<br>');
    if (introDesc) introDesc.textContent = contentData.intro.description;
    if (introBtn) introBtn.textContent = contentData.intro.btnText;
  }

  // Populate About Section
  if (contentData.about) {
    const aboutTitle = document.getElementById(contentData.about.titleId);
    const aboutDesc = document.getElementById(contentData.about.descriptionId);
    const aboutImg = document.getElementById(contentData.about.imageId);
    const pageTitle = document.getElementById(contentData.about.pageTitleId);
    const pageDesc = document.getElementById(contentData.about.pageDescriptionId);
    const pageImg = document.getElementById(contentData.about.pageImageId);
    const missionTitle = document.getElementById(contentData.about.missionTitleId);
    const missionText = document.getElementById(contentData.about.missionTextId);
    const whyTitle = document.getElementById(contentData.about.whyTitleId);
    
    if (aboutTitle) aboutTitle.textContent = contentData.about.title;
    if (aboutDesc) aboutDesc.textContent = contentData.about.description;
    if (aboutImg) aboutImg.src = contentData.about.imageUrl;
    if (pageTitle) pageTitle.textContent = contentData.about.pageTitle;
    if (pageDesc) pageDesc.textContent = contentData.about.pageDescription;
    if (pageImg) pageImg.src = contentData.about.pageImageUrl;
    if (missionTitle) missionTitle.textContent = contentData.about.missionTitle;
    if (missionText) missionText.textContent = contentData.about.missionText;
    if (whyTitle) whyTitle.textContent = contentData.about.whyTitle;
    
    // Loop through Why Points
    if (contentData.about.whyPoints) {
      contentData.about.whyPoints.forEach(point => {
        const pointElement = document.getElementById(point.id);
        if (pointElement) pointElement.textContent = point.text;
      });
    }

    // Populate Values / Mission / Culture section on home page
    const valuesMissionTitle = document.getElementById('values-mission-title');
    const valuesMissionText = document.getElementById('values-mission-text');
    const valuesCultureText = document.getElementById('values-culture-text');
    const valuesValuesText = document.getElementById('values-values-text');

    if (valuesMissionTitle) valuesMissionTitle.textContent = contentData.about.missionTitle;
    if (valuesMissionText) valuesMissionText.textContent = contentData.about.missionText;
    if (valuesCultureText) valuesCultureText.textContent = contentData.about.cultureText;

    if (valuesValuesText && contentData.about.values) {
      const parts = contentData.about.values.map(
        (val) => `${val.title} — ${val.description}`
      );
      valuesValuesText.textContent = parts.join('  ');
    }
  }

  // Populate Services Section
  if (contentData.services) {
    const servicesTitle = document.getElementById(contentData.services.titleId);
    const servicesDesc = document.getElementById(contentData.services.descriptionId);
    const servicesContainer = document.getElementById('services-container');
    
    console.log('Services container element:', servicesContainer);
    console.log('Service items to loop:', contentData.services.items);
    
    if (servicesTitle) servicesTitle.textContent = contentData.services.title;
    if (servicesDesc) servicesDesc.textContent = contentData.services.description;

    // Generate Service Items from JSON
    if (servicesContainer && contentData.services.items) {
      console.log('Generating services from JSON, count:', contentData.services.items.length);
      servicesContainer.innerHTML = ''; // Clear existing items
      
      contentData.services.items.forEach((item, index) => {
        console.log('Processing service item', index + 1, ':', item.title);
        const serviceHTML = `
          <div class="service-slide">
            <div class="service-image-container">
              <img src="${item.imageUrl}" alt="${item.title}" />
            </div>
            <div class="service-content">
              <h2>${item.title}</h2>
              <p>${item.description}</p>
              <a href="#" class="service-btn">Learn More</a>
            </div>
          </div>
        `;
        servicesContainer.insertAdjacentHTML('beforeend', serviceHTML);
      });
      console.log('All service items loaded. Total:', contentData.services.items.length);
    } else {
      console.log('Services container or items not found');
    }
  }

  // Populate Testimonials Section
  if (contentData.testimonials) {
    const testimonialsTitle = document.getElementById(contentData.testimonials.titleId);
    const testimonialsSubtitle = document.getElementById(contentData.testimonials.subtitleId);
    const carouselId = contentData.testimonials.carouselId || 'testimonials-carousel';
    const carousel = document.getElementById(carouselId);

    if (testimonialsTitle) testimonialsTitle.textContent = contentData.testimonials.title || '';
    if (testimonialsSubtitle) testimonialsSubtitle.textContent = contentData.testimonials.subtitle || '';

    if (carousel && Array.isArray(contentData.testimonials.items)) {
      carousel.innerHTML = '';

      contentData.testimonials.items.forEach((item) => {
        const quote = item.quote ? `"${item.quote}"` : '';
        const bg = item.imageUrl ? `--bg-image: url('${item.imageUrl}');` : '';
        const logoHtml = item.logoUrl
          ? `<div class="testimonial-logo"><img src="${item.logoUrl}" alt="${item.company || 'Client'}" /></div>`
          : '';

        const cardHtml = `
          <div class="testimonial-card" style="${bg}">
            <div class="testimonial-image">
              <div class="testimonial-arrow">↗</div>
            </div>
            <div class="testimonial-overlay">
              <div class="testimonial-content">
                <p class="testimonial-quote">${quote}</p>
              </div>
              <div style="display: flex; justify-content: space-between; align-items: flex-end;">
                <div>
                  <p class="testimonial-role">${item.role || ''}</p>
                  <p class="testimonial-company">${item.company || ''}</p>
                </div>
                ${logoHtml}
              </div>
            </div>
          </div>
        `;

        carousel.insertAdjacentHTML('beforeend', cardHtml);
      });
    }

    // Re-init carousel after dynamic render (safe, idempotent)
    // initTestimonialsCarousel();
  }

  // Populate Careers Section
  if (contentData.careers) {
    const careersTitle = document.getElementById('careers-title');
    const careersDescription = document.getElementById('careers-description');
    const careersDayInRole = document.getElementById('careers-dayInRole');
    const careersResponsibilities = document.getElementById('careers-responsibilities');
    const careersSchedule = document.getElementById('careers-schedule');
    const careersCompensation = document.getElementById('careers-compensation');
    const careersSalaryBands = document.getElementById('careers-salary-bands');
    const careersLookingFor = document.getElementById('careers-lookingFor');
    const careersGrowth = document.getElementById('careers-growth');
    
    if (careersTitle) careersTitle.textContent = contentData.careers.title || '';
    if (careersDescription) careersDescription.textContent = contentData.careers.description || '';
    if (careersDayInRole) careersDayInRole.textContent = contentData.careers.dayInRole || '';
    if (careersSchedule) careersSchedule.textContent = contentData.careers.schedule || '';
    if (careersCompensation) careersCompensation.textContent = contentData.careers.compensation || '';
    if (careersGrowth) careersGrowth.textContent = contentData.careers.growth || '';
    
    // Populate responsibilities list
    if (careersResponsibilities && contentData.careers.responsibilities) {
      careersResponsibilities.innerHTML = '';
      contentData.careers.responsibilities.forEach(resp => {
        const li = document.createElement('li');
        li.textContent = resp;
        careersResponsibilities.appendChild(li);
      });
    }
    
    // Populate looking for list
    if (careersLookingFor && contentData.careers.lookingFor) {
      careersLookingFor.innerHTML = '';
      contentData.careers.lookingFor.forEach(item => {
        const li = document.createElement('li');
        li.textContent = item;
        careersLookingFor.appendChild(li);
      });
    }

    // Populate salary bands grid
    if (careersSalaryBands && Array.isArray(contentData.careers.salaryBands)) {
      careersSalaryBands.innerHTML = '';
      contentData.careers.salaryBands.forEach((band) => {
        const card = document.createElement('div');
        card.className = 'salary-band-card';
        card.innerHTML = `
          <div class="salary-band-label">${band.label || ''}</div>
          <div class="salary-band-range">${band.range || ''}</div>
          ${band.description ? `<p class="salary-band-description">${band.description}</p>` : ''}
        `;
        careersSalaryBands.appendChild(card);
      });
    }
  }

  // Populate Community Section
  if (contentData.community) {
    const communityTitle = document.getElementById('community-title');
    const communityEngagement = document.getElementById('community-engagement');
    const communityCommitment = document.getElementById('community-commitment');
    
    if (communityTitle) communityTitle.textContent = contentData.community.title || '';
    if (communityEngagement) communityEngagement.textContent = contentData.community.engagement || '';
    if (communityCommitment) communityCommitment.textContent = contentData.community.commitment || '';
  }

  // Populate FAQ Section
  if (contentData.faq) {
    const faqTitle = document.getElementById('faq-title');
    const faqList = document.getElementById('faq-list');
    
    if (faqTitle) faqTitle.textContent = contentData.faq.title;
    
    // Generate FAQ Items from JSON
    if (faqList && contentData.faq.items) {
      faqList.innerHTML = ''; // Clear default items
      contentData.faq.items.forEach((item, index) => {
        const faqHTML = `
          <div class="faq-item">
            <button class="faq-question" data-index="${index}">
              <span>${item.question}</span>
              <span class="faq-toggle">▼</span>
            </button>
            <div class="faq-answer" data-index="${index}">
              <p>${item.answer}</p>
            </div>
          </div>
        `;
        faqList.insertAdjacentHTML('beforeend', faqHTML);
      });
      
      // Add click handlers for FAQ items
      initFAQAccordion();
    }
  }

  // Populate Contact Section
  if (contentData.contact) {
    const contactTitle = document.getElementById(contentData.contact.leftTitleId);
    const contactDesc = document.getElementById(contentData.contact.leftDescriptionId);
    const contactImg = document.getElementById(contentData.contact.leftImageId);
    
    if (contactTitle) contactTitle.textContent = contentData.contact.leftTitle;
    if (contactDesc) contactDesc.textContent = contentData.contact.leftDescription;
    if (contactImg) contactImg.src = contentData.contact.leftImageUrl;
    
    // Populate form fields
    if (contentData.contact.formFields) {
      contentData.contact.formFields.forEach((field) => {
        const formElement = document.getElementById(field.id);
        if (formElement) {
          formElement.placeholder = field.placeholder;
          if (field.type !== 'textarea') {
            formElement.type = field.type;
          }
        }
      });
    }

    // Populate footer contact locations from content.json -> contact.locations
    if (contentData.contact.locations && Array.isArray(contentData.contact.locations)) {
      const footerLocationsList = document.getElementById('footer-contact-locations');
      if (footerLocationsList) {
        footerLocationsList.innerHTML = '';

        contentData.contact.locations.filter(loc => loc.id !== null).forEach((loc, index) => {
          const li = document.createElement('li');
          if (index > 0) {
            li.style.marginTop = '20px';
          }

          const phoneHref = loc.phone
            ? 'tel:' + loc.phone.replace(/[^+\d]/g, '')
            : '';

          li.innerHTML = `
            <strong>${loc.name}</strong><br>
            ${loc.address}<br>
            ${loc.phone ? `<a href="${phoneHref}">${loc.phone}</a>` : ''}
          `;

          footerLocationsList.appendChild(li);
        });
      }
    }

    // Populate footer contact emails from content.json -> contact.emails
    if (contentData.contact.emails && Array.isArray(contentData.contact.emails)) {
      const footerEmailsList = document.getElementById('footer-contact-emails');
      if (footerEmailsList) {
        footerEmailsList.innerHTML = '';

        if (contentData.contact.emails.length > 0) {
          const li = document.createElement('li');
          li.innerHTML = contentData.contact.emails
            .map((email, idx) => {
              const separator = idx === 0 ? '' : '<br>';
              return `${separator}<a href="mailto:${email}">${email}</a>`;
            })
            .join('');

          footerEmailsList.appendChild(li);
        }
      }
    }
  }

  // Populate Footer Section
  if (contentData.footer) {
    const footerCols = document.querySelectorAll('.footer-col');
    const footerConfig = contentData.footer;
    const columns = footerConfig.columns || [];

    // First N-1 columns are standard link groups driven by footer.columns
    const standardColsCount = Math.min(columns.length, Math.max(footerCols.length - 1, 0));
    for (let i = 0; i < standardColsCount; i++) {
      const colEl = footerCols[i];
      const colConfig = columns[i];
      if (!colEl || !colConfig) continue;

      const items = colConfig.items || [];
      const itemsHtml = items
        .map(item => {
          if (!item) return '';
          const label = item.label || '';
          const href = item.href || '';
          if (!label) return '';
          return `<li>${href ? `<a href="${href}">${label}</a>` : label}</li>`;
        })
        .join('');

      colEl.innerHTML = `
        <h3>${colConfig.title || ''}</h3>
        <ul>
          ${itemsHtml}
        </ul>
      `;
    }

    // Contact footer column title (last column)
    if (footerCols.length > 0 && footerConfig.contactTitle) {
      const contactCol = footerCols[footerCols.length - 1];
      const contactHeading = contactCol.querySelector('h3');
      if (contactHeading) {
        contactHeading.textContent = footerConfig.contactTitle;
      }
    }

    // Footer bottom text
    const bottomTextEl = document.querySelector('.footer-bottom p');
    if (bottomTextEl && footerConfig.bottomText) {
      bottomTextEl.textContent = footerConfig.bottomText;
    }

    // Footer bottom links
    const bottomLinksEl = document.querySelector('.footer-bottom .footer-links');
    if (bottomLinksEl && Array.isArray(footerConfig.bottomLinks)) {
      bottomLinksEl.innerHTML = footerConfig.bottomLinks
        .map(link => {
          if (!link || !link.label) return '';
          const href = link.href || '#';
          return `<a href="${href}">${link.label}</a>`;
        })
        .join('');
    }
  }
}

// Load content when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  console.log('DOMContentLoaded fired');
  loadContent();
});


/* ---------------- NAVBAR SCROLL EFFECT ---------------- */

const nav = document.querySelector("nav");

window.addEventListener("scroll", () => {
  if (window.scrollY > 60) {
    nav.classList.add("scrolled");
  } else {
    nav.classList.remove("scrolled");
  }
});


/* ---------------- FADE IN ANIMATION ---------------- */

const faders = document.querySelectorAll(".fade");

const observer = new IntersectionObserver(entries => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add("show");
    }
  });
});

faders.forEach(el => observer.observe(el));


/* ---------------- SERVICES SCROLL EFFECT ---------------- */

function initServicesScroll() {
  const slides = document.querySelectorAll('.service-slide');
  const dotsContainer = document.getElementById('service-dots');
  const container = document.querySelector('.services-scroll-container');
  
  if (slides.length === 0) return;

  // Create dots
  slides.forEach((_, index) => {
    const dot = document.createElement('div');
    dot.className = 'dot' + (index === 0 ? ' active' : '');
    dot.addEventListener('click', () => showSlide(index));
    dotsContainer.appendChild(dot);
  });

  let currentIndex = 0;

  function showSlide(index) {
    slides.forEach(slide => slide.classList.remove('active'));
    document.querySelectorAll('.dot').forEach(dot => dot.classList.remove('active'));

    slides[index].classList.add('active');
    document.querySelectorAll('.dot')[index].classList.add('active');
    currentIndex = index;
  }

  // Show first slide
  showSlide(0);

  // Scroll through slides on scroll
  let scrollTimeout;
  let lastScrollTime = 0;

  const handleScroll = () => {
    const now = Date.now();
    if (now - lastScrollTime < 800) return; // Debounce
    lastScrollTime = now;

    const section = container.closest('.services-scroll-section');
    const rect = section.getBoundingClientRect();
    const sectionCenter = window.innerHeight / 2;

    if (rect.top < sectionCenter && rect.bottom > sectionCenter) {
      // Section is in view, enable scroll-based navigation
      const scrollDirection = event.deltaY > 0 ? 'down' : 'up';
      
      if (scrollDirection === 'down') {
        if (currentIndex < slides.length - 1) {
          showSlide(currentIndex + 1);
        }
      } else {
        if (currentIndex > 0) {
          showSlide(currentIndex - 1);
        }
      }
    }
  };

  window.addEventListener('wheel', handleScroll, { passive: true });

  // Also allow keyboard navigation
  document.addEventListener('keydown', (e) => {
    if (e.key === 'ArrowRight' && currentIndex < slides.length - 1) {
      showSlide(currentIndex + 1);
    } else if (e.key === 'ArrowLeft' && currentIndex > 0) {
      showSlide(currentIndex - 1);
    }
  });
}

// Initialize services scroll on DOM ready
document.addEventListener('DOMContentLoaded', () => {
  initServicesScroll();
  // Testimonials are initialized after rendering from content.json
});


/* ---------------- TESTIMONIALS CAROUSEL ---------- */

// function initTestimonialsCarousel() {
//   const carousel = document.getElementById('testimonials-carousel');
//   const cards = carousel ? carousel.querySelectorAll('.testimonial-card') : [];
//   const prevBtn = document.getElementById('testimonials-prev');
//   const nextBtn = document.getElementById('testimonials-next');
//   const arrows = carousel ? carousel.querySelectorAll('.testimonial-arrow') : [];

//   console.log('initTestimonialsCarousel called');
//   console.log('Found ' + cards.length + ' testimonial cards');
//   console.log('Found ' + arrows.length + ' arrows');

//   if (!carousel || cards.length === 0 || !prevBtn || !nextBtn) return;

//   let currentIndex = Math.floor(cards.length / 2); // Start with middle card
//   console.log('Starting at index:', currentIndex);

//   function updateCarousel() {
//     console.log('updateCarousel called, currentIndex:', currentIndex);
//     cards.forEach((card, index) => {
//       card.classList.remove('active');
//       if (index === currentIndex) {
//         card.classList.add('active');
//         console.log('Added active class to card', index);
//       }
//     });
//   }

//   function nextCard() {
//     currentIndex = (currentIndex + 1) % cards.length;
//     console.log('nextCard() - new index:', currentIndex);
//     updateCarousel();
//   }

//   function prevCard() {
//     currentIndex = (currentIndex - 1 + cards.length) % cards.length;
//     console.log('prevCard() - new index:', currentIndex);
//     updateCarousel();
//   }

//   // Event handlers (overwrite to avoid duplicate listeners on re-init)
//   nextBtn.onclick = () => {
//     console.log('Next button clicked');
//     nextCard();
//   };
//   prevBtn.onclick = () => {
//     console.log('Prev button clicked');
//     prevCard();
//   };

//   // Event listeners - Arrow icons (click to go to next)
//   arrows.forEach((arrow, index) => {
//     arrow.onclick = (e) => {
//       e.preventDefault();
//       e.stopPropagation();
//       console.log('Arrow ' + index + ' clicked');
//       nextCard();
//     };
//   });

//   // Keyboard navigation (only register once)
//   if (!window.__testimonialsKeyListener) {
//     document.addEventListener('keydown', (e) => {
//       const activeCarousel = document.getElementById('testimonials-carousel');
//       const activeCards = activeCarousel ? activeCarousel.querySelectorAll('.testimonial-card') : [];
//       if (!activeCarousel || activeCards.length === 0) return;

//       if (e.key === 'ArrowRight') nextCard();
//       if (e.key === 'ArrowLeft') prevCard();
//     });
//     window.__testimonialsKeyListener = true;
//   }

//   // Initialize
//   updateCarousel();
// }

// Initialize FAQ Accordion
function initFAQAccordion() {
  const faqQuestions = document.querySelectorAll('.faq-question');
  
  faqQuestions.forEach(button => {
    button.addEventListener('click', () => {
      const index = button.getAttribute('data-index');
      const answer = document.querySelector(`.faq-answer[data-index="${index}"]`);
      const isActive = answer.classList.contains('active');
      
      // Close all other open FAQs
      document.querySelectorAll('.faq-answer.active').forEach(openAnswer => {
        openAnswer.classList.remove('active');
        const openBtn = document.querySelector(`.faq-question[data-index="${openAnswer.getAttribute('data-index')}"]`);
        if (openBtn) openBtn.classList.remove('active');
      });
      
      // Toggle current FAQ
      if (!isActive) {
        answer.classList.add('active');
        button.classList.add('active');
      }
    });
  });
}

// Initialize Premium Services Section
function initPremiumServicesSection() {
  console.log('initPremiumServicesSection called');
  
  const wrapper = document.getElementById('services-premium-wrapper');
  const track = document.getElementById('services-premium-track');
  const titleElement = document.getElementById('services-premium-title');
  const descriptionElement = document.getElementById('services-premium-description');

  if (!wrapper || !track || !titleElement || !descriptionElement || !contentData.services) {
    console.log('Missing required elements or data');
    return;
  }

  const services = contentData.services.items;
  if (services.length === 0) return;

  console.log('Loading', services.length, 'services into premium section');

  // Create image items
  services.forEach((service) => {
    const imageItem = document.createElement('div');
    imageItem.className = 'services-premium-image-item';
    imageItem.innerHTML = `<img src="${service.imageUrl}" alt="${service.title}" />`;
    track.appendChild(imageItem);
  });

  // Constants
  const total = services.length;
  const gap = 80; // Must match CSS margin-bottom
  const viewport = window.innerHeight;
  const isMobile = window.innerWidth < 900;

  if (!isMobile) {
    // DESKTOP: Scroll-driven animation
    wrapper.style.height = (total * viewport + (total - 1) * gap) + 'px';

    // Scroll handler
    window.addEventListener('scroll', () => {
      const scrollY = window.scrollY;
      const wrapperTop = wrapper.offsetTop;
      let progress = scrollY - wrapperTop;

      if (progress >= 0 && progress <= wrapper.offsetHeight - viewport) {
        // Move images naturally with gap included
        track.style.transform = `translateY(-${progress}px)`;

        // Detect current index
        let index = Math.floor(progress / (viewport + gap));
        if (index >= total) index = total - 1;

        titleElement.textContent = services[index].title;
        descriptionElement.textContent = services[index].description;
      }
    });
  } else {
    // MOBILE: Carousel - show 1 service at a time
    let currentIndex = 0;
    
    // Update display to show current service
    function showService(index) {
      track.style.transform = `translateX(-${index * 100}%)`;
      titleElement.textContent = services[index].title;
      descriptionElement.textContent = services[index].description;
    }
    
    showService(0);
    
    // Add navigation buttons
    const mobileNav = document.createElement('div');
    mobileNav.className = 'services-mobile-nav';
    mobileNav.innerHTML = `
      <button class="services-nav-prev" id="services-prev">←</button>
      <div class="services-dots" id="services-dots"></div>
      <button class="services-nav-next" id="services-next">→</button>
    `;
    wrapper.appendChild(mobileNav);
    
    // Create dots
    const dotsContainer = document.getElementById('services-dots');
    services.forEach((_, i) => {
      const dot = document.createElement('button');
      dot.className = 'services-dot' + (i === 0 ? ' active' : '');
      dot.addEventListener('click', () => {
        currentIndex = i;
        showService(currentIndex);
        updateDots();
      });
      dotsContainer.appendChild(dot);
    });
    
    function updateDots() {
      document.querySelectorAll('.services-dot').forEach((dot, i) => {
        dot.classList.toggle('active', i === currentIndex);
      });
    }
    
    // Previous button
    document.getElementById('services-prev').addEventListener('click', () => {
      currentIndex = (currentIndex - 1 + total) % total;
      showService(currentIndex);
      updateDots();
    });
    
    // Next button
    document.getElementById('services-next').addEventListener('click', () => {
      currentIndex = (currentIndex + 1) % total;
      showService(currentIndex);
      updateDots();
    });
  }

  console.log('Premium services section initialized');
}

