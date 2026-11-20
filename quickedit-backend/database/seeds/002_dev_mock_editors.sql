-- Mock Users, Editors, Portfolios, and Sample Bookings
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Users (Clients, Editors, Admin)
INSERT INTO users (id, firebase_uid, email, email_verified, full_name, phone, avatar_url, status)
VALUES
(1, 'fb_client_1', 'maya.patel@quickedit.dev', 1, 'Maya Patel', '+919876543210', 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400', 'active'),
(2, 'fb_client_2', 'kabir.singh@quickedit.dev', 1, 'Kabir Singhania', '+919876543211', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200', 'active'),
(3, 'fb_editor_1', 'rohan.mehta@quickedit.dev', 1, 'Rohan Mehta', '+919876543220', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400', 'active'),
(4, 'fb_editor_2', 'priya.sharma@quickedit.dev', 1, 'Priya Sharma', '+919876543221', 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400', 'active'),
(5, 'fb_editor_3', 'arjun.verma@quickedit.dev', 1, 'Arjun Verma', '+919876543222', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400', 'active'),
(10, 'fb_admin_1', 'admin@quickedit.dev', 1, 'QuickEdit Operations Admin', '+919999999999', NULL, 'active')
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name);

-- User Roles
INSERT INTO user_roles (user_id, role)
VALUES
(1, 'client'),
(2, 'client'),
(3, 'editor'),
(4, 'editor'),
(5, 'editor'),
(10, 'admin')
ON DUPLICATE KEY UPDATE role = VALUES(role);

-- Client Profiles
INSERT INTO client_profiles (user_id, company_name, city, total_orders_count, total_spent)
VALUES
(1, 'D2C Audio Brand', 'Mumbai', 3, 7497.00),
(2, 'Tech Creator Media', 'Bengaluru', 1, 3999.00)
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);

-- Editor Profiles
INSERT INTO editor_profiles (user_id, headline, bio, city, years_experience, avg_delivery_days, starting_price, completed_projects_count, rating_avg, rating_count, verification_status, is_featured, is_available, payout_method_type, payout_upi_id)
VALUES
(3, 'Cinematic Reels & High-Retention Shorts Specialist', 'Professional video editor with 4+ years of experience editing for top Indian tech creators and lifestyle brands.', 'Mumbai', 4, 2, 1499.00, 142, 4.90, 128, 'approved', 1, 1, 'upi', 'rohan.upi@okhdfcbank'),
(4, 'Aesthetic Lifestyle, Travel Vlogs & Brand Commercials', 'Passionate visual storyteller focusing on travel, luxury fashion, and culinary stories.', 'New Delhi', 3, 2, 1200.00, 98, 4.80, 94, 'approved', 1, 1, 'upi', 'priya.upi@okicici'),
(5, 'Podcast Soundscapes & Longform Documentaries', 'Over 5 years mastering long-form narrative pacing and audio engineering.', 'Bengaluru', 5, 3, 2499.00, 180, 4.95, 160, 'approved', 1, 1, 'upi', 'arjun.upi@oksbi')
ON DUPLICATE KEY UPDATE headline = VALUES(headline);

-- Editor Specializations
INSERT INTO editor_specializations (editor_id, tag)
VALUES
(3, 'Reels'), (3, 'Shorts'), (3, 'Color Grading'), (3, 'Sound Design'),
(4, 'Travel Vlogs'), (4, 'Lifestyle'), (4, 'Motion Graphics'),
(5, 'Podcasts'), (5, 'Documentaries'), (5, 'Audio Mastering')
ON DUPLICATE KEY UPDATE tag = VALUES(tag);

-- Media Registry
INSERT INTO uploaded_media (id, uploader_id, context, object_key, original_filename, mime_type, size_bytes, status)
VALUES
(1, 1, 'booking_raw', 'raw/bk_2457/raw_footage.mov', 'raw_footage.mov', 'video/quicktime', 1395864371, 'uploaded'),
(2, 1, 'booking_raw', 'raw/bk_2457/brand_kit.zip', 'brand_kit.zip', 'application/zip', 262144000, 'uploaded'),
(3, 1, 'booking_raw', 'raw/bk_2457/music.mp3', 'music.mp3', 'audio/mpeg', 12582912, 'uploaded'),
(4, 3, 'portfolio', 'portfolio/ed_3/urban_streetwear.mp4', 'urban_streetwear.mp4', 'video/mp4', 52428800, 'uploaded')
ON DUPLICATE KEY UPDATE status = VALUES(status);

-- Editor Portfolios
INSERT INTO editor_portfolios (id, editor_id, title, category, video_media_id, duration_sec, view_count, is_showreel, moderation_status)
VALUES
(1, 3, 'Urban Streetwear Reel', 'reels', 4, 32, 18400, 1, 'approved')
ON DUPLICATE KEY UPDATE title = VALUES(title);

-- Sample Bookings
INSERT INTO bookings (id, order_code, client_id, editor_id, service_id, status, base_amount, addons_amount, platform_fee, total_amount, deadline_at)
VALUES
(1, '#QE2457', 1, 3, 2, 'editing', 1999.00, 500.00, 0.00, 2499.00, DATE_ADD(NOW(), INTERVAL 5 HOUR)),
(2, '#QE2458', 2, 3, 4, 'first_preview', 3499.00, 500.00, 0.00, 3999.00, DATE_ADD(NOW(), INTERVAL 2 DAY))
ON DUPLICATE KEY UPDATE status = VALUES(status);

-- Editor Ledger Entries
INSERT INTO editor_ledger (id, editor_id, booking_id, entry_type, amount, balance_after, description)
VALUES
(1, 3, 1, 'available_credit', 18450.00, 18450.00, 'Available Balance (November 2026 Earnings)'),
(2, 3, 2, 'pending_credit', 7200.00, 7200.00, 'Pending Clearance Balance')
ON DUPLICATE KEY UPDATE amount = VALUES(amount);

-- Support Tickets
INSERT INTO support_tickets (id, user_id, booking_id, ticket_code, subject, category, priority, status)
VALUES
(1, 1, 1, 'TK-102', 'Payment Clearance Inquiries for Order #QE2412', 'payment', 'medium', 'resolved'),
(2, 3, NULL, 'TK-105', 'Update IFSC code on bank account', 'account', 'low', 'open')
ON DUPLICATE KEY UPDATE subject = VALUES(subject);

SET FOREIGN_KEY_CHECKS = 1;
