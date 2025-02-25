from fpdf import FPDF

def generate_transaction_pdf(transactions, user_email):
    pdf = FPDF()
    pdf.set_auto_page_break(auto=True, margin=15)
    pdf.add_page()
    pdf.set_font("Arial", size=12)
    
    pdf.cell(200, 10, f"Historial de Transacciones - {user_email}", ln=True, align="C")
    pdf.ln(10)

    for transaction in transactions:
        pdf.cell(200, 10, f"{transaction['date']} - {transaction['sender_email']} -> {transaction['receiver_email']} - ${transaction['amount']}", ln=True)

    file_path = f"historial_{user_email}.pdf"
    pdf.output(file_path)
    
    return file_path
