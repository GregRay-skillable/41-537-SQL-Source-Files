SET IDENTITY_INSERT [dbo].[FAQ_Content] ON;

INSERT INTO [dbo].[FAQ_Content] (faq_id, category, question, answer, keywords, is_active, created_at, updated_at)
SELECT v.faq_id, v.category, v.question, v.answer, v.keywords, v.is_active, v.created_at, v.updated_at
FROM (VALUES
    (1, 'Orders', 'How do I track my order?', 'You can track your order from the Orders page by entering your order number and registered email address.', 'track order, order status, shipment', 1, '2026-03-15 09:16:13.850654', '2026-03-15 09:16:13.850654'),
    (2, 'Returns', 'How do I return a damaged item?', 'Go to the Returns page, select the damaged item option, upload photos if requested, and submit the return request.', 'return damaged item, broken product, refund', 1, '2026-03-15 09:16:13.850654', '2026-03-15 09:16:13.850654'),
    (3, 'Payments', 'What payment methods are supported?', 'We support major credit cards, debit cards, and selected digital wallets.', 'payment methods, card, wallet', 1, '2026-03-15 09:16:13.850654', '2026-03-15 09:16:13.850654'),
    (4, 'Shipping', 'Do you offer international shipping?', 'Yes, international shipping is available for selected regions during checkout.', 'international shipping, overseas delivery', 1, '2026-03-15 09:16:13.850654', '2026-03-15 09:16:13.850654'),
    (5, 'Support', 'How do I contact support?', 'You can contact support through live chat, email, or phone during business hours.', 'contact support, help desk, customer care', 1, '2026-03-15 09:16:13.850654', '2026-03-15 09:16:13.850654'),
    (6, 'Orders', 'Can I cancel my order after placing it?', 'Orders can be cancelled only before they are packed for shipment. Check your Orders page for the current status.', 'cancel order, stop order', 1, '2026-03-15 09:16:13.850654', '2026-03-15 09:16:13.850654'),
    (7, 'Refunds', 'When will I receive my refund?', 'Refunds are usually processed within 5 to 7 business days after the returned item is approved.', 'refund status, money back', 1, '2026-03-15 09:16:13.850654', '2026-03-15 09:16:13.850654'),
    (8, 'Shipping', 'How much does shipping cost?', 'Shipping cost is calculated during checkout based on destination, weight, and delivery speed.', 'shipping charges, delivery fee', 1, '2026-03-15 09:16:13.850654', '2026-03-15 09:16:13.850654'),
    (9, 'Account', 'How do I reset my password?', 'Select Forgot Password on the sign-in page and follow the verification steps sent to your registered email.', 'reset password, forgot password', 1, '2026-03-15 09:16:13.850654', '2026-03-15 09:16:13.850654'),
    (10, 'Returns', 'Can I exchange an item instead of returning it?', 'Exchange options are available for selected items and sizes. Check the Returns page for eligibility.', 'exchange item, replacement', 1, '2026-03-15 09:16:13.850654', '2026-03-15 09:16:13.850654'),
    (11, 'Orders', 'Why is my order delayed?', 'Order delays can happen because of payment verification, stock availability, or courier issues.', 'delayed order, late shipment', 1, '2026-03-15 09:16:13.850654', '2026-03-15 09:16:13.850654'),
    (12, 'Payments', 'Is cash on delivery available?', 'Cash on delivery is available only in selected locations and for eligible products.', 'cash on delivery, COD', 1, '2026-03-15 09:16:13.850654', '2026-03-15 09:16:13.850654'),
    (13, 'Support', 'What are your customer support hours?', 'Customer support is available Monday to Friday from 8 AM to 6 PM local time.', 'support hours, helpdesk timing', 1, '2026-03-15 09:16:13.850654', '2026-03-15 09:16:13.850654'),
    (14, 'Shipping', 'Can I change my delivery address?', 'You can update the delivery address before the order is packed. After shipment, address changes are not guaranteed.', 'change address, delivery address', 1, '2026-03-15 09:16:13.850654', '2026-03-15 09:16:13.850654'),
    (15, 'Returns', 'What if I received the wrong item?', 'Submit a return request under Wrong Item Received and our team will arrange replacement or refund.', 'wrong item, incorrect product', 1, '2026-03-15 09:16:13.850654', '2026-03-15 09:16:13.850654')
) v(faq_id, category, question, answer, keywords, is_active, created_at, updated_at)
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[FAQ_Content] c WHERE c.faq_id = v.faq_id);

SET IDENTITY_INSERT [dbo].[FAQ_Content] OFF;

