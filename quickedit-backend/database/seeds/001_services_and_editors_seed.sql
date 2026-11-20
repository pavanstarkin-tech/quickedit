-- QuickEdit Default Services & Mock Seed Data
-- For local / staging development

SET NAMES utf8mb4;

INSERT INTO services (id, slug, name, subtitle, description, icon_key, default_base_price, default_turnaround_hours, free_revisions_limit, extra_revision_price, is_active)
VALUES
(1, 'quick_edit', 'Quick Edit', '24 hrs • Up to 60s', 'Fast pacing cuts, basic color balance, clean transitions, and audio cleanup.', 'flash_on', 999.00, 24, 2, 299.00, 1),
(2, 'insta_reel', 'Insta Reel', '24-48 hrs • High Retention', 'Dynamic hooks, animated captions, sound effects, zoom-ins, and trending audio syncing.', 'camera_alt', 1499.00, 36, 2, 299.00, 1),
(3, 'youtube_short', 'YouTube Short', '24-48 hrs • Vertical 9:16', 'Engaging storytelling cuts, eye-catching text overlays, and sound design tuned for shorts.', 'play_arrow', 1299.00, 36, 2, 299.00, 1),
(4, 'youtube_long', 'YouTube Long', '2-4 days • 8-15 mins', 'Comprehensive pacing, multi-cam sync, B-roll insertions, motion graphics, and audio mastering.', 'smart_display', 2999.00, 72, 2, 499.00, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO service_addons (id, slug, name, description, price, turnaround_reduction_hours, is_active)
VALUES
(1, 'rush_delivery', 'Rush Delivery', 'Prioritize your project for turnaround in under 24 hours.', 500.00, 24, 1),
(2, 'extra_revision', 'Extra Revision', 'Additional complete revision cycle after free revisions are used.', 299.00, 0, 1),
(3, 'animated_captions', 'Animated Captions & Subtitles', 'Word-by-word karaoke style animated subtitles in matching brand colors.', 399.00, 0, 1),
(4, 'source_files', 'Raw Project / Source Files', 'Receive organized Adobe Premiere Pro (.prproj) or DaVinci Resolve project files.', 799.00, 0, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name);
