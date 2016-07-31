CREATE TABLE `yayinlar_hurriyet` (
  `id` int(5) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `channelname` varchar(255) NOT NULL,
  `schannelname` varchar(255) NOT NULL,
  `catname` varchar(255) NOT NULL DEFAULT 'televizyon',
  `typename` varchar(255) DEFAULT 'program',
  `startdate` varchar(255) NOT NULL,
  `day` date NOT NULL,
  `image` text NOT NULL,
  `pdesc` text NOT NULL,
  `channelid` int(5) NOT NULL,
  `udate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sdelete` int(2) DEFAULT '0',
  `timeline` varchar(255) NOT NULL DEFAULT 'televizyon',
  `weblink` varchar(255) NOT NULL DEFAULT 'televizyon'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `yayinlar_hurriyet`
--
ALTER TABLE `yayinlar_hurriyet`
  ADD PRIMARY KEY (`id`),
  ADD KEY `channelid` (`channelid`),
  ADD KEY `timeline` (`timeline`),
  ADD KEY `schannelname` (`schannelname`,`startdate`,`day`),
  ADD KEY `schannelname_2` (`schannelname`,`day`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `yayinlar_hurriyet`
--
ALTER TABLE `yayinlar_hurriyet`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;
