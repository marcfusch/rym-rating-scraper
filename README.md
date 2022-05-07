# RateYourMusic userrating scraper

This repository contains a bash script that scraps the general rating of a specific user list and outputs a coherent and useful .CSV file.

## Using the script

First, we need to clone the repo.
```
git clone https://github.com/marcfusch/rym-rating-scraper/
cd rym-rating-scraper/
```
Then, we can execute the script with the following command:
```
chmod 755 rym-rating-scraper.sh
./rym-rating-scraper.sh users.txt output.csv
```
Progress is shown during execution. The random waiting timer between curl requests is necessary or RYM will ban your IP. This does not mean that they can temporarily set a restriction page which can be lifted by a single captcha. See following paragraph

## Troubleshooting

It can happen that RateYourMusic banned your ip address (that's rare) or a captacha is required in order to let you access the site.
If that's the case, you will need to go manually to the website with the same ip address on your browser and complete the captcha.<br />
Once done, go to Dev Tools > Network > Record<br />
Then refresh the page and grab the session cookie, and replace the one on line 13 by yours.<br />
The script should now work properly.<br />
If, however, your ip has been banned, you are welcome to use a VPN in order to avoid the restriction.<br /><br />

Have a great scrap!
