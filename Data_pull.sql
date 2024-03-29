/****** Script for SelectTopNRows command from SSMS  ******/
-- ==================================================================
-- Select call data for selected accounts where scores are available.
-- ==================================================================

SELECT distinct RTRIM(c.[Acct_Nbr]) as acct_nbr					--Account Number
      ,convert(varchar, [Call_Date_Time], 1) as call_date_time	--Call Date and Time (Pacific Time)
      ,[LastStatus] as last_status								--Last Call Status ID
	  ,ss.Description as description							--Description of Last Status
      ,RTRIM([Status]) as status								--Booking Status ID
	  ,bs.BookingDescription as booking_description				--Booking Status Description
      ,[AgentID] as agent_id									--Agent ID
      ,c.[uKey] as ukey											--PK
      ,convert(varchar, [AcctDateTime], 1) as acct_date_time	--Account Date and Time of Call
      ,c.[SwitchCallkey] as switch_call_key						--Switch Call Key, FK
      ,[SecDuration] as sec_duration							--Call duration in seconds
	  ,cs.ScoreKey as score_key									--Call Score Key, FK
	  ,cs.score as score										--Overall Call Score
	  ,cs.ScoreOutOf as score_out_of							--Total Possible Call Score
	  ,score_percentage = score/ScoreOutOf						--Score Percentage
	  ,CASE when bsa.Industry = 'Hotel / Resorts' THEN 'Hotel'	--Industry of Peroperty: Hotel or Vacation Rental
			ELSE 'Vacation Rental' END AS Industry								
	  ,l.leadkey as leadkey										--Lead Key, FK
	  ,CASE when l.OrigAgent = 'Navis' THEN l.bookedAmount		--Revenue Booked
			ELSE ab.AcctBookingAmount END AS revenue
  FROM [TFT].[dbo].[TFTCalls] c
  left join TFT.dbo.TFTSwitchStatus ss on c.laststatus = ss.SwitchStatus
  left join tft.dbo.TFTBookingStatus bs on c.status = bs.bookingstatus and c.acct_nbr = bs.acct_nbr
  inner join tft.dbo.TFTCallScore cs on c.ukey = cs.CallKey
  inner join traffic.dbo.BFISubAccount bsa on c.acct_nbr = bsa.Acct_Nbr
  left join leadmanagement.dbo.elmleads l on c.switchcallkey = l.switchcallkey and c.Acct_Nbr = l.Acct_Nbr
  left join leadmanagement.dbo.elmacctbookings ab on l.leadkey = ab.leadkey and l.Acct_Nbr = ab.Acct_Nbr
  left join leadmanagement.dbo.ELMAcctNonBookings nb on l.leadkey = nb.leadkey and l.Acct_Nbr = nb.Acct_Nbr
  where bs.resorlead = 1
	and c.Direction = 'I'
	and c.acct_nbr in ('14551','15330','14631','14510','14588','14385','14310','12627','14520','14567','14596','14597','14328','14592','14513','14578','14409','14378')
	and c.SwitchCallkey != 0
  order by call_date_time asc

-- =======================================================
-- Select detailed call score data for selected accounts.
-- =======================================================

SELECT distinct RTRIM(c.[Acct_Nbr]) as acct_nbr					--Account Number
      ,[AgentID] as agent_id									--Agent ID
      ,c.[uKey] as ukey											--PK
      ,c.[SwitchCallkey] as switch_call_key						--Switch Call Key, FK
	  ,cs.ScoreKey as score_key									--Score Key, FK
	  ,css.criteria												--Criteria that is being scored
	  ,css.answer as answer										--Answer of whether criteria was met
	  ,css.points as points										--Points awarded for criteria
	  ,css.templatename as template_name						--Template name for call scoring
	  ,css.tftcallscoresheetid									--Call Score Sheet ID, FK
	  ,CASE when bsa.Industry = 'Hotel / Resorts' THEN 'Hotel'	--Industry of Peroperty: Hotel or Vacation Rental
			ELSE 'Vacation Rental' END AS Industry								
  FROM [TFT].[dbo].[TFTCalls] c
  left join TFT.dbo.TFTSwitchStatus ss on c.laststatus = ss.SwitchStatus
  left join tft.dbo.TFTBookingStatus bs on c.status = bs.bookingstatus and c.acct_nbr = bs.acct_nbr
  inner join tft.dbo.TFTCallScore cs on c.ukey = cs.CallKey
  inner join tft.dbo.TFTCallScoreSheet css on cs.scorekey = css.scorekey
  inner join traffic.dbo.BFISubAccount bsa on c.acct_nbr = bsa.Acct_Nbr
  where bs.resorlead = 1
	and c.Direction = 'I'
	and c.acct_nbr in ('14551','15330','14631','14510','14588','14385','14310','12627','14520','14567','14596','14597','14328','14592','14513','14578','14409','14378')
	and c.SwitchCallkey != 0

-- =======================================================
-- Select unscored calls for selected accounts.
-- =======================================================

SELECT distinct RTRIM(c.[Acct_Nbr]) as acct_nbr					--Account Number
      ,convert(varchar, [Call_Date_Time], 1) as call_date_time	--Call Date and Time (Pacific Time)
      ,[LastStatus] as last_status								--Last Call Status ID
	  ,ss.Description as description							--Last Call Status Description
      ,RTRIM([Status]) as status								--Booking Status ID
	  ,bs.BookingDescription as booking_description				--Booking Status Description
      ,[AgentID] as agent_id									--Agent ID
      ,c.[uKey] as ukey											--PK
      ,convert(varchar, [AcctDateTime], 1) as acct_date_time	--Account Date and Time
      ,c.[SwitchCallkey] as switch_call_key						--Switch Call Key, FK
      ,[SecDuration] as sec_duration							--Call duration in seconds
	  ,CASE when bsa.Industry = 'Hotel / Resorts' THEN 'Hotel'	--Industry of Peroperty: Hotel or Vacation Rental
			ELSE 'Vacation Rental' END AS Industry								
	  ,l.leadkey as leadkey										--Lead Key, FK
	  ,CASE when l.OrigAgent = 'Navis' THEN l.bookedAmount		--Revenue Booked
			ELSE ab.AcctBookingAmount END AS revenue
  FROM [TFT].[dbo].[TFTCalls] c
  left join TFT.dbo.TFTSwitchStatus ss on c.laststatus = ss.SwitchStatus
  left join tft.dbo.TFTBookingStatus bs on c.status = bs.bookingstatus and c.acct_nbr = bs.acct_nbr
  inner join traffic.dbo.BFISubAccount bsa on c.acct_nbr = bsa.Acct_Nbr
  left join leadmanagement.dbo.elmleads l on c.switchcallkey = l.switchcallkey and c.Acct_Nbr = l.Acct_Nbr
  left join leadmanagement.dbo.elmacctbookings ab on l.leadkey = ab.leadkey and l.Acct_Nbr = ab.Acct_Nbr
  left join leadmanagement.dbo.ELMAcctNonBookings nb on l.leadkey = nb.leadkey and l.Acct_Nbr = nb.Acct_Nbr
  where NOT EXISTS 
   (SELECT * FROM tft.dbo.tftcallscore cs WHERE c.ukey = cs.callkey)
    and bs.resorlead = 1
	and c.Direction = 'I'
	and c.acct_nbr in ('14551','15330','14631','14510','14588','14385','14310','12627','14520','14567','14596','14597','14328','14592','14513','14578','14409','14378')
	and c.SwitchCallkey != 0
  order by call_date_time asc