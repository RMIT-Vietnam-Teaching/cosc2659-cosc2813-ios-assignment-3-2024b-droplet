const functions = require("firebase-functions");
const stripe = require("stripe")(functions.config().stripe.secret_key);
exports.createPaymentIntent = functions.https.onCall(async (data, context) =>{
  const amount = data.amount;
  const currency = "vnd";
  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount,
      currency: currency,
      payment_method_types: ["card"],
    });
    return {clientSecret: paymentIntent.client_secret};
  } catch (error) {
    return {error: error.message};
  }
});
