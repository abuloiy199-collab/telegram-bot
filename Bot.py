from telegram import Update
from telegram.ext import Application, MessageHandler, filters, ContextTypes
from openai import OpenAI

TELEGRAM_TOKEN = ""
OPENAI_API_KEY = ""

client = OpenAI(api_key=OPENAI_API_KEY)

async def handle(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user_text = update.message.text

    try:
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": "أنت مساعد ذكي."},
                {"role": "user", "content": user_text}

            ]
        )

        reply = response.choices[0].message.content
    except Exception as e:
        reply = f"خطأ: {e}"

    await update.message.reply_text(reply)

def main():
    app = Application.builder().token(TELEGRAM_TOKEN).build()
    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle))

    print("Bot is running...")
    app.run_polling()

if __name__ == "__main__":
    main()
