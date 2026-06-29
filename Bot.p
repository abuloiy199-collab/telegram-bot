import os
from telegram import Update
from telegram.ext import Application, MessageHandler, filters, ContextTypes
from openai import OpenAI

# 🔐 مفاتيح من البيئة (أفضل وأأمن طريقة)
TELEGRAM_TOKEN = os.getenv("TELEGRAM_TOKEN")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

# ⚠️ تأكد أن المفاتيح موجودة
if not TELEGRAM_TOKEN or not OPENAI_API_KEY:
    raise ValueError("Missing API keys. Set TELEGRAM_TOKEN and OPENAI_API_KEY")

client = OpenAI(api_key=OPENAI_API_KEY)

# 🤖 التعامل مع الرسائل
async def handle(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user_text = update.message.text

    try:
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": "أنت مساعد ذكي، تجيب باختصار وباللغة العربية."},
                {"role": "user", "content": user_text}
            ]
        )

        reply = response.choices[0].message.content

    except Exception as e:
        reply = f"حدث خطأ: {e}"

    await update.message.reply_text(reply)

# 🚀 تشغيل البوت
def main():
    app = Application.builder().token(TELEGRAM_TOKEN).build()

    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle))

    print("Bot is running...")
    app.run_polling()

if __name__ == "__main__":
    main()
