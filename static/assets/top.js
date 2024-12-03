// Lightweight Visitor Counter
(function() {
    // Configuration
    const STORAGE_KEY = 'site_visitor_count';
    const API_ENDPOINT = 'https://api.countapi.xyz/hit/blog.52013120.xyz/visitors';

    // Function to get or create a unique visitor ID
    function getVisitorId() {
        // Use a combination of IP-like identifier and timestamp
        let visitorId = localStorage.getItem('visitor_id');
        
        if (!visitorId) {
            // Generate a pseudo-unique ID
            visitorId = Date.now().toString(36) + Math.random().toString(36).substr(2);
            localStorage.setItem('visitor_id', visitorId);
        }
        
        return visitorId;
    }

    // Function to fetch and update visitor count
    async function updateVisitorCount() {
        try {
            // Use CountAPI.xyz for simple, free visitor counting
            const response = await fetch(API_ENDPOINT);
            const data = await response.json();
            
            // Create or update the visitor count display
            const counterElement = document.getElementById('visitor-counter');
            if (counterElement) {
                counterElement.textContent = data.value;
            }
        } catch (error) {
            console.error('Error fetching visitor count:', error);
        }
    }

    // Function to create and style the counter element
    function createCounterElement() {
        const counterElement = document.createElement('div');
        counterElement.id = 'visitor-counter';
        counterElement.style.cssText = `
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            background-color: rgba(0,0,0,0.7);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            z-index: 1000;
        `;
        document.body.appendChild(counterElement);
        return counterElement;
    }

    // Initialize the visitor counter
    function initVisitorCounter() {
        // Ensure the page is fully loaded
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => {
                createCounterElement();
                updateVisitorCount();
            });
        } else {
            createCounterElement();
            updateVisitorCount();
        }
    }

    // Run the initialization
    initVisitorCounter();
})();
