
#### Average Weekly Earnings ####

# Time Series Definitions

# "KAB9" = Total Pay
# "KAC2" = Total Pay YoY Growth
# "KAC3" = Total Pay 3-month average YoY Growth
# "KAI7" = Regular Pay
# "KAI8" = Regular Pay YoY Growth
# "KAI9" = Regular Pay 3-month average YoY Growth
# "A3WX" = Real Total Pay
# "A3WV" = Real Total Pay YoY Growth
# "A3WW" = Real Total Pay 3-month average YoY Growth
# "A2FC" = Real Regular Pay
# "A2F9" = Real Regular Pay YoY Growth
# "A2FA" = Real Regular Pay 3-month average YoY Growth

# Get AWE Data

awe <- pdfetch_ONS(c("KAB9", "KAC2", "KAC3", "KAI7", "KAI8", "KAI9", "A3WX", "A3WV", "A3WW", "A2FC", "A2F9", "A2FA"), "lms")

colnames(awe) <- c("Total Pay", "Total Pay YoY Growth", "Total Pay 3-month average YoY Growth",
                   "Regular Pay", "Regular Pay YoY Growth", "Regular Pay 3-month average YoY Growth",
                   "Real Total Pay", "Real Total Pay YoY Growth", "Real Total Pay 3-month average YoY Growth",
                   "Real Regular Pay", "Real Regular Pay YoY Growth", "Real Regular Pay 3-month average YoY Growth")
