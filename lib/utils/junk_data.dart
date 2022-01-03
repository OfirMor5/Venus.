import 'package:hera2/models/baby_details.dart';

List<String> getMaternityBagItems() => [
      'ID',
      'Pregnancy tracking card',
      'Up-to-date blood count',
      'Mask for you and the attendant',
      'Towel',
      'Hair brush',
      'Rubber bands and hairpins',
      'Bathroom ware',
      'Toothbrush for you and the attendant',
      'Toothpaste',
      'Hygienic lipstick',
      'Pads',
      'A kit for collecting umbilical cord blood',
      'Mobile charger / backup battery for smartphone',
      'Camera',
      'Flip-flops for the shower',
      'Changeable clothes',
      'A pair of warm socks',
      'Medications / Vitamins',
      'Bottle of water',
      'Energy bars / dried fruits / sandwiches / nuts',
      'Small money for vending machines',
      'wet wipes',
      'Absorbent underwear',
      'Deodorant',
      'Alcohol gel',
      'Slippers',
      'Nursing bra',
      'Book',
      'Blindfold',
      'Earplugs',
      'Breastfeeding shirt',
      'Clothes for you to leave the hospital',
    ];

List<String> getBabyBagItems() => [
      'Clothing for hospital discharge',
      'Blanket',
      'Socks',
      'Hat',
      'Diapers',
      'Cloth diapers',
      'Wipes',
      'Diaper ointment',
      'Towel',
      'pacifier',
      'A car seat',
      'Your pediatrician’s contact information',
      'Bottles',
    ];

List<String> getShopingListItemsForBaby() => [
      'Crib / Bed',
      'Mattress for Crib / Bed',
      'Blanket',
      'Bedclothes',
      'Changing table',
      'Changing mat',
      'Padding for the changing mat',
      'Mobile for bed',
      'Breastfeeding armchair',
      'Pacifiers',
      'Breastfeeding pads',
      'Breast milk pump',
      'Bottles',
      'Bags for storing pumped milk',
      'Nipple ointment',
      'Breastfeeding apron',
      'Breastfeeding bras',
      'Nursing pillow',
      'Additional nipples for bottles',
      'Sterilizer',
      'Clothes',
      'Baby stroller',
      'Car safety seat',
      'Trolley bag',
      'Toys',
    ];

Map<String, List<String>> getHospitalsMap() => {
      'Northern District': [
        'HaEmek',
        'Baruch Padeh, Poriya',
        'Galilee',
        'EMMS Nazareth',
        'French Nazareth',
        'Holy Family',
        'Rebecca Sieff'
      ],
      'Haifa District': [
        'Carmel',
        'Dekel',
        'Hillel Yaffe',
        'Bnai Zion',
        'Rambam',
        'Elisha'
      ],
      'Central District': [
        'Ganim Sanatorium',
        'Meir',
        'Laniado',
        'Bellinson',
        'Rabin',
        'Kaplan',
      ],
      'Tel Aviv District': [
        'Mayanei Hayeshua',
        'Herzliya Medical Center',
        'Wolfson',
        'Sheba',
        'Ramat Marpe',
        'Assuta',
        'Reuth',
        'Tzarfati'
      ],
      'Jerusalem District': [
        'Hadassah Ein Kerem',
        'Shaare Zedek',
        'Bikur Cholim',
        'Hadassah Mount Scopus',
        'Augusta Victoria',
        'Makassed',
      ],
      'Southern District': [
        'Assuta Ashdod',
        'Barzilai',
        'Soroka',
        'Yoseftal',
      ],
    };

Map<String, List<String>> getPregnancyRightsMap() => {
      'Notice of pregnancy before hiring': [
        "A job applicant is not required to notify a potential employer that she is pregnant.\nA potential employer may not ask a candidate questions on this subject."
      ],
      'When to notify the employer of pregnancy': [
        "An employee must notify the employer of her pregnancy, at the latest, in the fifth month of pregnancy."
      ],
      'Restriction of work in the vicinity of heat source, hazardous materials or radiation':
          [
        "Once the employer learns that the worker is pregnant, he is not allowed to employ her in close proximity to a heat source, in exposure to substances specified in women's work regulations and in work safety regulations, as well as in exposure to ionizing radiation and radioactive contamination above the regulations."
      ],
      'Absence for medical examinations and supervision': [
        "An employee employed for a full working week may be absent for up to 40 hours during pregnancy, if she is employed for a full working week for more than 4 hours a day, and up to 20 hours during pregnancy, if she is employed for less than 4 hours a day for a working week."
      ],
      'Absence due to miscarriage': [
        "An aborted worker may be absent from work for one week after the abortion.\nIf a doctor confirms that the medical condition due to the abortion requires a longer absence, the employee is entitled to be absent from work for the period specified in the medical certificate - up to six weeks after the abortion."
      ],
      'Absence due to pregnancy preservation': [
        "An employee may be absent from work during the months of pregnancy, if a doctor has confirmed in writing that her medical condition on the occasion of pregnancy requires it."
      ],
      'Provisions for a provident fund during the period of absence due to the preservation of pregnancy':
          [
        "The employer must continue to transfer payments to a provident fund for the period for which the employee is entitled to a maternity benefit"
      ],
      'Absence due to risk involved in work': [
        "An employee may be absent from work during the months of pregnancy, if the employer has not found a suitable alternative job for her."
      ],
      'Limitation of dismissals and worsening of conditions': [
        "An employer may not dismiss a pregnant worker, or impair the scope of employment or income of a pregnant worker, who worked for him or her for a job for six months, unless he can use dismissals by the Ministry of Labor, Welfare and Social Services. This is whether it means a permanent, temporary employee."
      ],
      'A worker employed by a manpower contractor': [
        "The prohibition on dismissal applies to the manpower contractor, and the actual employer may not cause the dismissal of the employee unless it can be dismissed by the Ministry of Labor, Welfare and Social Services."
      ],
      'Absence of an employee due to the pregnancy of his spouse': [
        "An employee may take up to seven days of absence from work per year, at the expense of sick days accrued to his credit, due to treatments or tests becoming pregnant by his spouse"
      ],
      'Enforcement of the provisions of labor laws': [
        "The Ministry of Labor, Welfare and Social Services and Industry has powers for administrative and criminal enforcement of various provisions of the Labor Laws. In the area of equal opportunities at work and foreign workers, there are also civil enforcement powers."
      ],
    };

BabyDetails getBabyDetails(int week) {
  String description = "";
  String isLike = "";
  switch (week) {
    case 0:
    case 1:
      isLike = "Your baby has yet to be conceived.";
      description =
          "This is week one of your pregnancy, but you're not officially pregnant yet. It might seem confusing, but your doctor will track your pregnancy and due date from the first day of your last period. Right now, your body is busy getting ready for when you do get pregnant. Your uterus is thickening so it can house and feed your fertilized egg once it implants. Now is the time to be patient and take good care of yourself.";
      break;
    case 2:
      isLike = "Your baby has yet to be conceived.";
      description =
          "You still don't feel any different, but right now you're at the most fertile time of the month — you're ovulating! If a sperm makes its way to a waiting egg in your fallopian tube, you're going to conceive. A few days later, you could notice some light spotting. It might look like your period, but it's actually a sign that the fertilized egg has attached itself to the wall of your uterus.";
      break;
    case 3:
      isLike = 'Your baby is as big as a vanilla bean seed.';
      description =
          "Finally, you're pregnant! Sperm and egg have officially merged into one single cell, called a zygote. Inside that cell, a lot is going on. Chromosomes from you and your partner are combining to decide your baby's gender, hair, and eye color — even their budding personality! As the zygote speeds down the fallopian tubes toward the uterus, it will keep dividing. Two cells will become four, four will become eight, and so on. These cells will eventually create every organ in your baby's body.";
      break;
    case 4:
      isLike = "Your baby is as big as a poppy seed.";
      description =
          "Now that the embryo has attached to the wall of your uterus, the real work begins. Cells are dividing that will create all of your baby's organs. A fluid-filled cushion called the amniotic sac is forming. It will surround and protect your baby while they grow. Attached to it will be the yolk sac, which will feed baby in these early weeks. Your baby may be big enough to see on ultrasound now, but just barely. They are smaller than a grain of rice.";
      break;
    case 5:
      isLike = "Your baby is as big as an orange seed.";
      description =
          "You still might not recognize your baby yet. At this stage, they look like a tiny collection of tubes. But those tubes have important purposes! One tube is forming a brain and spinal cord. Another is developing into baby's heart. Tiny buds on either side of the body will grow into arms and legs. As your baby keeps growing, you might feel the first twinges of pregnancy symptoms, such as sore breasts, morning sickness, and the constant urge to urinate.";
      break;
    case 6:
      isLike = "Your baby is as big as a sweet pea.";
      description =
          "Ba-bum, ba-bum. It's way too quiet for you to hear, but your baby's tiny heart has started to beat. That heart sits inside a body that's now almost 1/2-inch long from the top of the head to the rump — about as wide as a pencil eraser. Baby still looks like a tadpole but that won't last for long. Human features are starting to emerge, including two eyes that come complete with lids. The lungs and digestive system are also starting to branch out, forming the organs that will help your baby breathe and eat in just a few months.";
      break;
    case 7:
      isLike = "Your baby is as big as a blueberry.";
      description =
          "Even though you're only in your second month, your baby's body is already forming every organ it will need — including the heart, kidneys, liver, lungs, and intestines. Buds are sprouting from baby's growing arms. Right now they look like paddles, but eventually they'll form hands and feet. Your baby is attached to you by an umbilical cord. Through this connection, you'll provide food, and filter away your baby's wastes until you deliver.";
      break;
    case 8:
      isLike = "Your baby is as big as a raspberry.";
      description =
          "You might not look pregnant yet, but you probably feel it! If the morning sickness hasn't set in, you're at least feeling more tired than usual. Inside your uterus, your baby is developing at a rapid pace. In fact, they have officially graduated from embryo to fetus! If you peeked inside right now, you'd see the beginnings of a face on your bean-sized baby. You could make out two eyes, a nose, ears, and an upper lip. Your baby's body is also starting to straighten out.";
      break;
    case 9:
      isLike = "Your baby is as big as a green olive.";
      description =
          "Your baby weighs about 1/8 of an ounce — just bigger than a penny. The tadpole-like tail is almost gone, and in its place are two little legs. Your baby's head is still huge compared to the body, but it will get more proportional in the weeks to come. Inside, the reproductive organs are forming — although it's still too early to tell on an ultrasound whether you're having a boy or girl. If you look closely, though, you might see your baby move!";
      break;
    case 10:
      isLike = "Your baby is as big as a prune.";
      description =
          "Bye-bye tail! That early appendage is now completely gone. Also gone is the webbing between baby's fingers and toes. Your baby now has a real profile with well-defined eyes, mouth, and ears. Baby's eyes are wide open now, but soon the eyelids will close — at least temporarily. Inside baby's brain, the connections are forming that will one day help them ace a math test, or possibly play the cello.";
      break;
    case 11:
      isLike = "Your baby is as big as a large strawberry.";
      description =
          "Your baby has become very active, though you probably can't feel any flutters just yet. Baby still only measures just 2 inches long from the top of the head to the rump — about the size of a prune. Most of that is the head, which makes up about half of your baby's entire body! In a few weeks, baby's head and body will become more proportional. Also happening this week — your baby is growing fingernails and irises — the part of the eye that controls how much light enters.";
      break;
    case 12:
      isLike = "Your baby is as big as a lime.";
      description =
          "You've reached the end of your first trimester — a major milestone! By the end of this week, your risk of having a miscarriage drops significantly, and you might want to start telling friends and family that you're expecting. By now you've put on 2 to 5 pounds, and your baby looks like a fully formed person. Inside, more organs are developing. Baby's kidneys are getting ready to produce urine. Your little one also has teeth, as well as fingers and toes — complete with nails.";
      break;
    case 13:
      isLike = "Your baby is as big as a lemon.";
      description =
          "Hopefully you're over any morning sickness you had. Now, you should be putting on weight. It won't be long before friends and co-workers start to notice your baby bump! Your baby is growing quickly now and is getting more proportional – now the head makes up only 1/3 of your baby's body. Helping your baby grow is the placenta, which is serving up a steady supply of nutrients and disposing of wastes. If you're having a girl, their ovaries are already filled with hundreds to thousands of eggs.";
      break;
    case 14:
      isLike = "Your baby is as big as a navel orange.";
      description =
          "Your baby is right around 4 inches long from the top of the head to the rump and weighs about 4 1/2 ounces — roughly the size of a small peach. Like a peach, their body is covered with soft hairs. These are called lanugo, and they're like a little coat providing warmth in the womb. Don't worry — this fine covering of fur should be gone by your due date. Baby is also becoming an individual! |They are developing fingerprints, including on the thumb, which might have already found its way into baby's mouth.";
      break;
    case 15:
      isLike = "Your baby is as big as a pear.";
      description =
          "It's very clear what's going on right now inside your baby's body. Baby's skin is so thin you can see right through it! Look closely, and you'll be able to see a network of fine blood vessels forming. Baby's muscles are getting stronger, and they are testing them out by moving around, making fists, and trying out different facial expressions. At one of your next visits, your doctor should offer you a quad screening test to check for Down syndrome and other chromosome problems.";
      break;
    case 16:
      isLike = "Your baby is as big as a large onion.";
      description =
          "By now, your baby is nearly 5 inches long from the top of the head to the rump and weighs close to 4 ounces — about the size of a small apple. And you're probably enjoying a pregnancy glow right now. If your cheeks look flushed and healthy, it's because your blood volume has increased to supply your growing baby! There are also some downsides to this extra blood flow, including nosebleeds and bigger leg veins. Ask your doctor for tips to deal with these issues.";
      break;
    case 17:
      isLike = "Your baby is as big as a large onion.";
      description =
          "All systems are a go — or nearly there — inside your growing baby. The lungs are breathing in amniotic fluid. Blood is pumping around the circulatory system. The kidneys are filtering urine. Your baby's looks are changing, as hair, eyebrows, and eyelashes grow in. Your body is changing, too. You might have trouble buttoning your blouse now, because your breasts have grown in preparation to feed your baby. Some women get a full cup size bigger.";
      break;
    case 18:
      isLike = "Your baby is as big as a cucumber.";
      description =
          "Are you feeling the first flutters of movement? You might be, because baby is now 5 1/2 inches long from the top of the head to the rump and weighs about 5 ounces. That's about the size of a small cell phone and big enough to cause a stir with every roll. Start talking to your baby. Their ears are developed enough to hear you! In the next week or two, you'll get to see what baby looks like during your first pregnancy ultrasound. You can also learn whether you're having a boy or girl — that is if you want to know!";
      break;
    case 19:
      isLike = "Your baby is as big as a mango.";
      description =
          "The amniotic fluid that surrounds and protects your baby can also irritate their delicate skin. That's why baby's body is now coated with a waxy, white substance called vernix caseosa. It should be gone before birth, unless your baby is born early. Under the skin, a layer of fat is forming to provide warmth. As baby's hair grows in, you might notice your own hair getting thicker. This is because your normal hair shedding cycle has slowed down. Enjoy your thick mane while it lasts!";
      break;
    case 20:
      isLike = "Your baby is as big as a sweet potato.";
      description =
          "You're halfway through your pregnancy! In about 20 weeks, you'll get to meet your baby for the very first time. Inside you, baby can hear and may respond to sounds. Talk or sing — even if you can't carry a tune — so your baby can get familiar with your voice. By now, baby measures 6 1/2 inches from the top of the head to the rump and weighs about 11 ounces — roughly the size of a small banana. Your baby will keep growing, and so will you. Expect to gain about 1/2 pound a week from here on out.";
      break;
    case 21:
      isLike = "Your baby is as big as a large banana.";
      description =
          "A lot is going on under the surface of your tummy! Tiny tooth buds are popping up in baby's gums. The intestines are starting to produce meconium, the sticky, tarry-looking waste that you'll see in baby's first few dirty diapers. Rapid eye movements may occur. And the bone marrow is ramping up its production of red blood cells, which will soon deliver oxygen to baby's body. Friends and co-workers should already be commenting on your growing belly, and congratulating you on your upcoming arrival!";
      break;
    case 22:
      isLike = "Your baby is as big as a red bell pepper.";
      description =
          "This week your baby is almost 1 pound and 8 inches long from the top of the head to the rump! All sorts of systems are forming inside your baby, including hormones that will give their organs the commands they need to operate, and the nerves baby needs to touch, smell, and experience all sorts of other sensations. Baby's sex organs are also developing now. In boys, the testes have started to descend. In girls, the uterus, ovaries, and vagina are where they should be.";
      break;
    case 23:
      isLike = "Your baby is as big as a grapefruit.";
      description =
          "Your baby has passed the 1-pound mark and is almost developed enough to survive outside the womb, but you've still got a few more months to go. Now it's time for baby to practice for life out in the world. The lungs continue to get ready to breathe by inhaling amniotic fluid. They're also producing a substance called surfactant, which will allow the lungs to inflate. Baby's brain is making the connections needed to think — and negotiate with you some day!";
      break;
    case 24:
      isLike = "Your baby is as big as a pomegranate.";
      description =
          "Your baby now weighs more than a pound and extends almost a foot long from the top of the head to the rump — stretched out that's about as big as a jumbo ballpark hotdog. Your baby has now reached viability – meaning that the baby would most likely survive with the help of a ventilator if delivery had to take place. In weeks past, baby's skin was as wrinkled as a prune. But those wrinkles are filling in and smoothing out as fat builds up underneath. Fingernails are present. As your own belly expands, you may notice stretch marks forming across your abdomen. These should fade after you deliver. Between now and week 28, your doctor should give you a glucose screening test to check for gestational diabetes.";
      break;
    case 25:
      isLike = "Your baby is as big as an eggplant.";
      description =
          "Your baby is getting bigger — weighing in at a pound-and-a-half — about the size of a head of broccoli. The window into the amazing world inside your baby is closing, as their skin goes from see-through to cloudy. Yet baby's heartbeat is becoming clearer. If your partner puts an ear against your belly, a faint and fast bah-boom, bah-boom may be strong enough to hear. You might also feel a gentle hiccup or two emanating from your belly.";
      break;
    case 26:
      isLike = "Your baby is as big as an acorn squash.";
      description =
          "Your baby is a 2-pound bundle of joy. They weigh about the same as the quart of milk you drink from daily to get your recommended 1,200 mg of calcium. For the first time since your baby's eyelids formed, they've opened, revealing bluish-colored eyes. Don't get too attached to the color — it might change in the first few months of life. There isn't much to see inside your uterus, but if you shine a light on your abdomen, your baby might react with a flurry of movement.";
      break;
    case 27:
      isLike = "Your baby is as big as a cabbage.";
      description =
          "You've entered your third trimester — the home stretch! Your baby is starting to look like they will at delivery, but inside, the organs still have some maturing to do. That includes the brain, which is quickly making the connections needed to control baby's body. By now baby has settled into a regular schedule, alternating between periods of sleep and wakefulness. Unfortunately, baby's schedule might not be the same as yours. Don't be surprised if a few kicks jolt you awake at night.";
      break;
    case 28:
      isLike = "Your baby is as big as a head of lettuce.";
      description =
          "By now your baby measures about 10 inches long from the top of the head to the rump and weighs more than 2 pounds — about as large as a squash. They can do all sorts of things — blink, cough, hiccup, and possibly even dream! Baby is moving into position for childbirth, which is getting closer every day. If they are facing rump first, don't panic. There's still time to move into a headfirst position. That's something you can discuss with your ob-gyn, who you'll be seeing more of now, with visits about once every 2 weeks during a normal pregnancy.";
      break;
    case 29:
      isLike = "Your baby is as big as a head of cauliflower.";
      description =
          "Baby is growing at a rapid rate, and because there's less room in the womb, you should be able to feel just about every movement. Some of those elbow and knee jabs will be pretty intense as baby's bones and muscles get stronger. Every other part of baby's body is maturing too, from lungs to brain. That brain is developing more wrinkles as nerve cell connections are established. Baby's senses are also becoming more aware of sound, light, and touch.";
      break;
    case 30:
      isLike = "Your baby is as big as a bunch of broccoli.";
      description =
          "This week your baby measures about 11 inches long from the top of the head to the rump, and tips the scales at nearly 3 pounds — about the size of a small roasting chicken. As your baby grows, your belly is growing to match. That can be uncomfortable, and awkward, as your center of balance shifts. You might notice your feet expanding too, as your joints loosen up in preparation for labor. If that's the case, a shopping trip for a bigger pair of shoes may be in order.";
      break;
    case 31:
      isLike = "Your baby is as big as a coconut.";
      description =
          "You're putting on about a pound a week, and your baby is plumping up too. To get your body ready for labor, you may be starting to have Braxton Hicks contractions. These practice contractions can last from 30 seconds to 2 minutes. If contractions get more intense or closer together, call your doctor to make sure you're not in labor for real. Baby's lungs are still developing, and they would need the help of a ventilator to breathe if you gave birth right now.";
      break;
    case 32:
      isLike = "Your baby is as big as a cantaloupe.";
      description =
          "Your baby, at almost 4 pounds, is like a cantaloupe weighing down your belly! There isn't much room left in your uterus, but somehow your little bundle will still manage to wriggle and squirm around in there, though maybe not as forcefully as before. Your baby is making final preparations for their appearance. The fine covering of body hair called lanugo is falling off, and hair only remains where it's meant to be — on the eyelashes, eyebrows, and head.";
      break;
    case 33:
      isLike = "Your baby is as big as a butternut squash.";
      description =
          "This week your baby's body continues to plump up, while the bones underneath harden to support it. The only bones that will stay soft are inside your baby's skull, which will need to compress slightly to fit through the birth canal. There will still be soft spots in your baby's skull throughout the first few years, to allow the brain to grow. Meanwhile, your growing girth is making you more uncomfortable, with afflictions ranging from heartburn to hemorrhoids. Don't worry — only a few more weeks to go!";
      break;
    case 34:
      isLike = "Your baby is as big as a pineapple.";
      description =
          "Right now your baby measures more than 12 inches from the top of the head to the rump, and weighs 5 pounds — about the size of a large pineapple. Most of the major organs — digestive, respiratory, and nervous systems — are almost able to work on their own. Your baby may already be in the head-down position, ready for delivery! Space in your uterus is tight these days, so don't be surprised if you see an errant elbow or knee poking out from your belly.";
      break;
    case 35:
      isLike = "Your baby is as big as a spaghetti squash.";
      description =
          "There may not be much room left in your uterus, with your baby weighing in at nearly 5 1/2 pounds, but now the serious growth begins. For the next few weeks, your baby will put on 1/2 pound or more a week. Baby is also settling into position lower in your pelvis for delivery – this movement is called lightening. That's good news for your lungs — breathing should get easier now — but bad news for your bladder, which will start to feel more pressure. As a result, you'll be spending even more time in the bathroom.";
      break;
    case 36:
      isLike = "Your baby is as big as a bunch of kale.";
      description =
          "In just a few days, your baby will be considered full-term. At almost 6 pounds — about the size of a honeydew melon — your child's body is just about ready for birth. The waxy, white substance called vernix caseosa that covered much of their body during this 9-month journey has dissolved. Baby has swallowed this and other substances, which will form the blackish-green meconium bowel movements you'll find in baby's first diapers. From now until the end of your pregnancy, you'll see your ob-gyn at least once a week.";
      break;
    case 37:
      isLike = "Your baby is as big as a canary melon.";
      description =
          "Your pregnancy is now full-term, and your baby is just about full-sized. At a weight of 6 1/2 pounds, it's like you're carrying around a small bowling ball! Baby is getting ready for labor, which could be a couple of weeks away — or any day now! Their head is moving into position in your pelvis, which is called engaged. Baby's immune system is also arming up, and will keep developing after birth. If you breastfeed, you'll boost baby's immune system even more.";
      break;
    case 38:
      isLike = "Your baby is as big as a mini watermelon.";
      description =
          "You're in the home stretch! Baby now weighs more than 6 1/2 pounds. Much of that weight is a layer of fat, which will help keep them warm in the outside world. Your baby's growth has slowed down, but the organs should all be working now. The brain has started to control the functions of the entire body — from breathing to regulating the heart rate. Reflexes are also active — including the grasping and sucking that allow baby to grab your hand and latch on to a breast soon after birth.";
      break;
    case 39:
      isLike = "Your baby is as big as a honeydew melon.";
      description =
          "At just over 7 pounds, your baby is like a little watermelon in your belly — and you can feel every ounce. You are probably more than ready to be done with the heartburn, backaches, and constant bathroom visits and ready to meet your baby already! You won't have to wait much longer. Baby could be born any day now. You may notice more Braxton Hicks contractions as your body prepares for labor. If they get more regular and intense, it is time to call the doctor.";
      break;
    case 40:
      isLike = "Your baby is as big as a small pumpkin.";
      description =
          "This is the week when you should finally get to meet the squirmy little bundle you've been carrying around for the last 9 months! However, often babies don't cooperate and arrive on schedule. If yours decides to stick around in your womb past your due date, talk to your doctor about whether they will cause you to go into labor, also known as inducing. Your baby is now full-sized. Although newborn sizes can vary, the average baby weighs 7 pounds, and measures 20 inches long from the top of the head to the rump.";
      break;
  }
  return BabyDetails(week: week, description: description, isLike: isLike);
}

getTestsByWeek(int week) {
  switch (week) {
    case 0:
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
      return ["Blood test to identify carriers of hereditary diseases"];
      break;
    case 6:
    case 7:
    case 8:
    case 9:
      return [
        "Blood test for blood count, blood and Rh type, fasting sugar",
        "Syphilis antibodies, and urine test for general and for culture",
        "Ultrasound"
      ];
      break;

    case 10:
      return ["Ultrasound", "Chorionic villus sampling test"];
      break;

    case 11:
    case 12:
      return [
        "Ultrasound",
        "Chorionic villus sampling test",
        "Nuchal translucency determined on ultrasound examination",
        "Blood test for PAPP-A and for free beta HCG"
      ];
    case 13:
      return [
        "Nuchal translucency determined on ultrasound examination",
        "Blood test for PAPP-A and for free beta HCG",
        "​Early ultrasound fetal anatomy survey	"
      ];
    case 14:
    case 15:
      return ["​Early ultrasound fetal anatomy survey"];
      break;
    case 16:
      return [
        "​Early ultrasound fetal anatomy survey",
        "Triple Screen Test (fetoprotein, HCG, estriol)",
        "Amniotic fluid test"
      ];
      break;
    case 17:
      return [
        "​Early ultrasound fetal anatomy survey	",
        "Triple Screen Test (fetoprotein, HCG, estriol)",
        "Amniotic fluid test"
      ];
      break;
    case 18:
      return [
        "Triple Screen Test (fetoprotein, HCG, estriol)",
        "Amniotic fluid test"
      ];
      break;
    case 19:
    case 20:
      return [
        "Triple Screen Test (fetoprotein, HCG, estriol)",
        "Amniotic fluid test",
        "Ultrasound examination for a “basic” fetal anatomy survey",
      ];
      break;
    case 21:
    case 22:
    case 23:
      return [
        "Amniotic fluid test",
        "Ultrasound examination for a “basic” fetal anatomy survey",
      ];
      break;
    case 24:
    case 25:
      return [
        "Amniotic fluid test",
        "Ultrasound examination for a “basic” fetal anatomy survey",
        "Blood count, glucose tolerance test. Rh antibodies (as needed)"
      ];
      break;
    case 26:
    case 27:
    case 28:
      return [
        "Amniotic fluid test",
        "Blood count, glucose tolerance test.\nRh antibodies (as needed)"
      ];
      break;
    case 29:
    case 30:
    case 31:
    case 32:
    case 33:
    case 34:
    case 35:
    case 36:
    case 37:
    case 38:
    case 39:
    case 40:
      return [
        "​Ultrasound examination during the third trimester",
        "Amniotic fluid test"
      ];
  }
}
