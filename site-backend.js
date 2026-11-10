(function () {
  const form = document.getElementById("f");
  const status = document.getElementById("ok");
  if (!form || !status) return;

  const configured = window.AURA_SUPABASE_URL &&
    window.AURA_SUPABASE_ANON_KEY &&
    !window.AURA_SUPABASE_URL.includes("https://gecndkidqkawlndctxrt.supabase.co") &&
    !window.AURA_SUPABASE_ANON_KEY.includes("YOUR_SUPABASE");

  if (!configured || !window.supabase) {
    console.warn("Aura Farm backend is not configured. Enquiry form remains in demo mode.");
    return;
  }

  const client = window.supabase.createClient(
    window.AURA_SUPABASE_URL,
    window.AURA_SUPABASE_ANON_KEY
  );

  form.onsubmit = async function (event) {
    event.preventDefault();
    const name = form.elements.n.value.trim();
    const phone = form.elements.p.value.trim();
    const interest = form.elements.t.value;
    const message = form.elements.m.value.trim();

    if (name.length < 2 || !/^[0-9০-৯]{10,15}$/.test(phone.replace(/[\s\-+()]/g, "")) || message.length < 10) {
      status.textContent = document.documentElement.lang === "bn"
        ? "অনুগ্রহ করে সঠিক নাম, ফোন নম্বর ও বিস্তারিত লিখুন।"
        : "Please enter a valid name, phone number and enquiry details.";
      return;
    }

    const button = form.querySelector('button[type="submit"]');
    button.disabled = true;
    button.textContent = document.documentElement.lang === "bn" ? "পাঠানো হচ্ছে..." : "Sending...";

    const { error } = await client.from("enquiries").insert([{
      customer_name: name,
      phone: phone,
      interest: interest,
      message: message,
      status: "new"
    }]);

    button.disabled = false;
    button.textContent = document.documentElement.lang === "bn" ? "জিজ্ঞাসা পাঠান" : "Send enquiry";

    if (error) {
      console.error(error);
      status.textContent = document.documentElement.lang === "bn"
        ? "দুঃখিত, তথ্য পাঠানো যায়নি। কিছুক্ষণ পর আবার চেষ্টা করুন অথবা ফোন করুন।"
        : "Sorry, your enquiry could not be sent. Please try again or call the farm.";
      return;
    }

    form.reset();
    status.textContent = document.documentElement.lang === "bn"
      ? "ধন্যবাদ! আপনার জিজ্ঞাসা সফলভাবে জমা হয়েছে। আমরা যোগাযোগ করব।"
      : "Thank you! Your enquiry has been submitted. We will contact you soon.";
  };
})();
