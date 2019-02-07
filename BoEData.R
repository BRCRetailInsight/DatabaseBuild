
#### Bank of England Time Series ####
#Collect all data upto the latest data point

# Secured lending
boe_secured <- pdfetch_BOE("LPMVTVJ", from = "1993-01-01", to = Sys.Date())
colnames(boe_secured) <- "Secured Lending"

# Consumer Credit
boe_conscredit <- pdfetch_BOE("LPMB3PS", from = "1993-01-01", to = Sys.Date())
colnames(boe_conscredit) <- "Consumer Credit"

# Credit Cards
boe_ccards <- pdfetch_BOE("LPMVZQX", from = "1993-01-01", to = Sys.Date())
colnames(boe_ccards) <- "Credit Cards"

# Mortgage Approvals
boe_house <- pdfetch_BOE("LPMVTVX", from = "1993-01-01", to = Sys.Date())
colnames(boe_house) <- "Mortgage Approvals"

# Sterling Effective Exchange Rate
boe_gbp <- pdfetch_BOE("XUMABK67", from = "1980-01-01", to = Sys.Date())
colnames(boe_gbp) <- "Sterling Effective Exchange Rate"
