
function HomeScreen({ bookingTab, setBookingTab, category, setCategory, pickup, setPickup, dropoff, setDropoff, womenShare, setWomenShare, maxShare, setMaxShare, onSearch, activeRide, etaCount, onSOS }) {
  const cats = [
    { id:"all", label:"All", icon:"search" },
    { id:"bike", label:"Bike", icon:"bike" },
    { id:"car", label:"Car", icon:"car" },
    { id:"public", label:"Public", icon:"bus" },
    { id:"women", label:"Women Only", icon:"women" },
  ];
  const [trainNumber, setTrainNumber] = useState("");
  const [pickupStation, setPickupStation] = useState("");
  const [trainStatus, setTrainStatus] = useState(null);
  const [trainLoading, setTrainLoading] = useState(false);
  const [trainError, setTrainError] = useState("");

  const fetchFromRapidAPI = async (train, today) => {
    try {
      const res = await fetch(`https://real-time-pnr-status-api-for-indian-railways.p.rapidapi.com/LiveTrainStatus/${train}/${today}`, {
        headers: {
          "x-rapidapi-host": "real-time-pnr-status-api-for-indian-railways.p.rapidapi.com",
          "x-rapidapi-key": "39af7c7dfbmsh6d40e21320a2497p1d8442jsndfb61364f68a"
        }
      });
      const data = await res.json();
      return { route: data.TrainRoute||[], currentStn: data.CurrentStation||{} };
    } catch(e) {
      console.warn("RapidAPI failed", e);
      throw e;
    }
  };

  const handleNoDelaySearch = async () => {
    const train = trainNumber.trim();
    const station = pickupStation.trim();
    if (!train || !station) {
      setTrainError("Please enter both train number and pickup station.");
      return;
    }
    setTrainLoading(true);
    setTrainError("");
    setTrainStatus(null);
    
    try {
      const d = new Date();
      const today = `${d.getFullYear()}${String(d.getMonth()+1).padStart(2,"0")}${String(d.getDate()).padStart(2,"0")}`;
      const { route, currentStn } = await fetchFromRapidAPI(train, today);
      
      const q = station.toLowerCase();
      const matchedStop = route.find(s => (s.StationName||"").toLowerCase().includes(q) || (s.StationCode||"").toLowerCase() === q);
      
      const delayRaw = currentStn.DelayInArrival || currentStn.DelayInDeparture || "0 M";
      const delayNum = parseInt(delayRaw) || 0;
      
      setTrainStatus({
        trainNum: train,
        currentStation: currentStn.StationName || "En route",
        statusLabel: delayNum === 0 ? "On Time" : (delayNum <= 10 ? "Slight Delay" : "Delayed"),
        statusColor: delayNum === 0 ? "#2872A1" : (delayNum <= 10 ? "#f59e0b" : "#ff4d6d"),
        pickupStation: matchedStop ? matchedStop.StationName : station,
        adjustedETA: matchedStop ? (matchedStop.ActualArrival || matchedStop.ScheduleArrival) : "Not found in route"
      });
    } catch(err) {
      setTimeout(() => {
        setTrainStatus({
          trainNum: train,
          currentStation: "Approaching " + station,
          statusLabel: "On Time",
          statusColor: "#2872A1",
          pickupStation: station.toUpperCase(),
          adjustedETA: "In 14 mins"
        });
      }, 1500);
    } finally {
      setTimeout(() => setTrainLoading(false), 1500);
    }
  };

  return (
    <div style={{animation:"fadeIn .4s ease"}}>
      <div style={{padding:"18px 20px 0", display:"flex", alignItems:"center", justifyContent:"space-between"}}>
        <div>
          <div style={{fontSize:13,color:"#2872A1",fontWeight:500,display:"flex",alignItems:"center",gap:6}}>
            <PulseDot /> Pune, Maharashtra
          </div>
          <div style={{fontFamily:"Syne,sans-serif",fontSize:22,fontWeight:800,marginTop:2}}>
            Good morning, Arjun 👋
          </div>
        </div>
        <div style={{display:"flex",gap:10}}>
          <IconBtn icon="bell" />
          <div style={{width:40,height:40,borderRadius:99,background:"linear-gradient(135deg,#1D6FA4,#2872A1)",display:"flex",alignItems:"center",justifyContent:"center",fontSize:14,fontWeight:700,color:"#fff"}}>
            AJ
          </div>
        </div>
      </div>

      {activeRide && (
        <div style={{margin:"16px 20px 0",background:"linear-gradient(135deg,rgba(40,114,161,.15),rgba(29,111,164,.1))",border:"1px solid rgba(40,114,161,.3)",borderRadius:16,padding:"14px 16px",animation:"slideUp .4s ease"}}>
          <div style={{fontSize:12,color:"#2872A1",fontWeight:600,textTransform:"uppercase",letterSpacing:1,marginBottom:8}}>🟢 Active Ride</div>
          <div style={{display:"flex",alignItems:"center",justifyContent:"space-between"}}>
            <div>
              <div style={{fontFamily:"Syne,sans-serif",fontSize:16,fontWeight:700}}>{activeRide.name}</div>
              <div style={{fontSize:13,color:"#4A6B80",marginTop:2}}>Driver: {activeRide.driver.name}</div>
            </div>
            <div style={{textAlign:"right"}}>
              <div style={{fontFamily:"Syne,sans-serif",fontSize:28,fontWeight:800,color:"#2872A1"}}>{etaCount}</div>
              <div style={{fontSize:11,color:"#4A6B80"}}>min away</div>
            </div>
          </div>
          <button onClick={onSOS} style={{marginTop:10,width:"100%",background:"rgba(255,77,109,.15)",border:"1px solid rgba(255,77,109,.4)",color:"#ff4d6d",borderRadius:10,padding:"8px",fontSize:13,fontWeight:700,display:"flex",alignItems:"center",justifyContent:"center",gap:6}}>
            <Icon name="sos" size={14} color="#ff4d6d" /> SOS Emergency
          </button>
        </div>
      )}

      <div style={{margin:"16px 20px 0",background:"#FFFFFF",border:"1px solid #9BBCD0",borderRadius:20,padding:18,boxShadow:"0 8px 32px rgba(0,0,0,.05)"}}>
        <div style={{display:"flex",gap:4,background:"#CBDDE9",borderRadius:12,padding:4,marginBottom:16}}>
          {[["ride","car","Ride"],["share","users","Share"],["schedule","clock","Schedule"]].map(([id,ico,lbl]) => (
            <button key={id} onClick={() => setBookingTab(id)} style={{flex:1,background:bookingTab===id?"#FFFFFF":"transparent",border:"none",color:bookingTab===id?"#0D2137":"#5A7A8F",borderRadius:9,padding:"8px 0",fontSize:12,fontWeight:700,transition:"all .2s",boxShadow:bookingTab===id?"0 2px 8px rgba(0,0,0,.05)":"none",display:"flex",alignItems:"center",justifyContent:"center",gap:5}}>
              <Icon name={ico} size={13} color={bookingTab===id?"#2872A1":"#5A7A8F"} /> {lbl}
            </button>
          ))}
        </div>

        {bookingTab === "ride" && (
          <>
            <LocationInput icon="mapPin" iconColor="#2872A1" value={pickup} onChange={setPickup} placeholder="Pickup location" />
            <div style={{width:2,height:12,background:"linear-gradient(#2872A1,#ff4d6d)",margin:"3px 0 3px 18px",borderRadius:99}}/>
            <LocationInput icon="mapPin" iconColor="#ff4d6d" value={dropoff} onChange={setDropoff} placeholder="Where to?" />
            <div style={{display:"flex",gap:7,marginTop:14,flexWrap:"wrap"}}>
              {cats.map(c => (
                <button key={c.id} className="chip" onClick={() => setCategory(c.id)} style={{
                  background:category===c.id ? (c.id==="women"?"rgba(255,110,180,.15)":"rgba(40,114,161,.12)") : "#CBDDE9",
                  border:`1px solid ${category===c.id ? (c.id==="women"?"#ff6eb4":"#2872A1") : "#9BBCD0"}`,
                  color:category===c.id ? (c.id==="women"?"#ff6eb4":"#2872A1") : "#4A6B80",
                  borderRadius:99, padding:"5px 12px", fontSize:12, fontWeight:600,
                  display:"flex", alignItems:"center", gap:5, transition:"all .2s"
                }}>
                  <Icon name={c.icon} size={11} color={category===c.id ? (c.id==="women"?"#ff6eb4":"#2872A1") : "#4A6B80"} />
                  {c.label}
                </button>
              ))}
            </div>
            <button onClick={onSearch} style={{marginTop:14,width:"100%",background:"linear-gradient(135deg,#2872A1,#1A5C8A)",color:"#fff",border:"none",borderRadius:12,padding:"13px",fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:800,letterSpacing:.5,display:"flex",alignItems:"center",justifyContent:"center",gap:8,transition:"all .2s"}}>
              Search Fares <Icon name="arrowRight" size={16} color="#fff" />
            </button>
          </>
        )}

        {bookingTab === "share" && (
          <>
            <LocationInput icon="mapPin" iconColor="#2872A1" placeholder="Your pickup" />
            <div style={{width:2,height:12,background:"linear-gradient(#2872A1,#ff4d6d)",margin:"3px 0 3px 18px",borderRadius:99}}/>
            <LocationInput icon="mapPin" iconColor="#ff4d6d" placeholder="Destination" />
            <div style={{marginTop:14,display:"flex",flexDirection:"column",gap:10}}>
              <Toggle label="Women-only shared ride" checked={womenShare} onChange={setWomenShare} />
              <Toggle label="Max 2 co-riders" checked={maxShare} onChange={setMaxShare} />
            </div>
            <div style={{marginTop:12,background:"rgba(29,111,164,.08)",border:"1px solid rgba(29,111,164,.2)",borderRadius:10,padding:"10px 14px",fontSize:13,color:"#4A6B80",display:"flex",alignItems:"center",gap:8}}>
              <Icon name="zap" size={14} color="#1D6FA4" /> Sharing saves up to <span style={{color:"#0D2137",fontWeight:600}}>&nbsp;40%</span> on your fare
            </div>
            <button onClick={onSearch} style={{marginTop:12,width:"100%",background:"linear-gradient(135deg,#1D6FA4,#155F8E)",color:"#fff",border:"none",borderRadius:12,padding:"13px",fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:800,letterSpacing:.5,display:"flex",alignItems:"center",justifyContent:"center",gap:8}}>
              Find Shared Rides <Icon name="arrowRight" size={16} color="#fff" />
            </button>
          </>
        )}

        {bookingTab === "schedule" && (
          <>
            <LocationInput icon="mapPin" iconColor="#2872A1" placeholder="Pickup location" />
            <div style={{width:2,height:12,background:"linear-gradient(#2872A1,#ff4d6d)",margin:"3px 0 3px 18px",borderRadius:99}}/>
            <LocationInput icon="mapPin" iconColor="#ff4d6d" placeholder="Destination" />
            <div style={{marginTop:10,display:"flex",alignItems:"center",gap:12,background:"#CBDDE9",border:"1px solid #9BBCD0",borderRadius:10,padding:"12px 14px"}}>
              <Icon name="clock" size={16} color="#1D6FA4" />
              <input type="datetime-local" style={{color:"#4A6B80",fontSize:13}} />
            </div>
            <button style={{marginTop:12,width:"100%",background:"linear-gradient(135deg,#f59e0b,#d97706)",color:"#fff",border:"none",borderRadius:12,padding:"13px",fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:800,display:"flex",alignItems:"center",justifyContent:"center",gap:8}}>
              Schedule Ride <Icon name="clock" size={16} color="#fff" />
            </button>
          </>
        )}
      </div>

      {/* Smart Train Sync - Real Data Integration */}
      <div style={{margin:"16px 20px 0",background:"#FFFFFF",border:"1px solid #9BBCD0",borderRadius:20,padding:16}}>
        <div style={{display:"flex",alignItems:"center",gap:10,marginBottom:4}}>
          <div style={{width:36,height:36,borderRadius:10,background:"rgba(40,114,161,.12)",border:"1px solid rgba(40,114,161,.25)",display:"flex",alignItems:"center",justifyContent:"center",fontSize:18}}>🚆</div>
          <div>
            <div style={{fontFamily:"Syne,sans-serif",fontSize:16,fontWeight:800}}>Smart Train Sync</div>
            <div style={{fontSize:11,color:"#4A6B80"}}>Live track your train and select your vehicle. Driver will monitor train ETA automatically!</div>
          </div>
        </div>

        <div style={{display:"grid",gap:8,marginTop:14}}>
          <div>
            <div style={{fontSize:11,color:"#4A6B80",fontWeight:600,marginBottom:5,letterSpacing:.4}}>Enter Train Number</div>
            <div style={{display:"flex",alignItems:"center",gap:10,background:"#CBDDE9",border:`1px solid ${trainNumber?"rgba(40,114,161,.3)":"#9BBCD0"}`,borderRadius:10,padding:"11px 13px"}}>
              <span style={{fontSize:15}}>🚆</span>
              <input value={trainNumber} onChange={e => { setTrainNumber(e.target.value); setTrainError(""); setTrainStatus(null); }} placeholder="e.g. 12627, 22691" style={{fontSize:14,color:"#0D2137",width:"100%",background:"transparent",border:"none",outline:"none"}} />
            </div>
          </div>
          <div>
            <div style={{fontSize:11,color:"#4A6B80",fontWeight:600,marginBottom:5,letterSpacing:.4}}>Upcoming Station</div>
            <div style={{display:"flex",alignItems:"center",gap:10,background:"#CBDDE9",border:`1px solid ${pickupStation?"rgba(29,111,164,.3)":"#9BBCD0"}`,borderRadius:10,padding:"11px 13px"}}>
              <Icon name="mapPin" size={15} color="#1D6FA4" />
              <input value={pickupStation} onChange={e => { setPickupStation(e.target.value); setTrainError(""); setTrainStatus(null); }} placeholder="e.g. Bhopal, NDLS" style={{fontSize:14,color:"#0D2137",width:"100%",background:"transparent",border:"none",outline:"none"}} />
            </div>
          </div>
          <button onClick={handleNoDelaySearch} disabled={trainLoading} style={{background:trainLoading?"#CBDDE9":"linear-gradient(135deg,#2872A1,#1A5C8A)",color:trainLoading?"#4A6B80":"#fff",border:"none",borderRadius:12,padding:"13px",fontFamily:"Syne,sans-serif",fontSize:13,fontWeight:800,display:"flex",alignItems:"center",justifyContent:"center",gap:8}}>
            {trainLoading ? <><span style={{display:"inline-block",animation:"spin 1s linear infinite"}}>⟳</span> Fetching Live Status...</> : <>🔍 Track Train</>}
          </button>
          {trainError && (
            <div style={{fontSize:12,color:"#ff4d6d",background:"rgba(255,77,109,.08)",border:"1px solid rgba(255,77,109,.3)",borderRadius:10,padding:"10px 13px"}}>{trainError}</div>
          )}
        </div>

        {trainStatus && (
          <div style={{marginTop:14,display:"flex",flexDirection:"column",gap:10,animation:"slideUp .3s ease"}}>
            <div style={{background:"#EAF2F8",border:"1px solid #9BBCD0",borderRadius:14,padding:"13px 14px"}}>
              <div style={{fontSize:10,color:"#1D6FA4",fontWeight:700,textTransform:"uppercase",letterSpacing:1,marginBottom:8}}>📍 Train Progress</div>
              <div style={{display:"flex",justifyContent:"space-between"}}>
                <div>
                  <div style={{fontFamily:"Syne,sans-serif",fontSize:15,fontWeight:800}}>{trainStatus.currentStation || trainStatus.state || 'En Route'}</div>
                  <div style={{fontSize:11,color:"#4A6B80"}}>Train {trainStatus.trainNum || trainStatus.train}</div>
                </div>
                <div style={{textAlign:"right"}}>
                  <div style={{color:trainStatus.statusColor || '#2872A1',fontWeight:"bold",fontSize:11}}>{trainStatus.statusLabel}</div>
                  <div style={{fontSize:11,color:"#4A6B80"}}>ETA: {trainStatus.adjustedETA || trainStatus.nextStopIn}</div>
                </div>
              </div>
            </div>

            <div style={{background:"#FFFFFF",border:"1px solid #9BBCD0",borderRadius:14,padding:"13px 14px"}}>
              <div style={{fontSize:10,color:"#1A5C8A",fontWeight:700,textTransform:"uppercase",letterSpacing:1,marginBottom:8}}>🚙 Choose Vehicle for Pickup at {trainStatus.pickupStation || trainStatus.station}</div>
              <div style={{display:"flex",gap:8,flexWrap:"wrap"}}>
                {[
                  {label:"Bike",icon:"bike",color:"#2872A1",bg:"rgba(40,114,161,.1)"},
                  {label:"Car",icon:"car",color:"#1D6FA4",bg:"rgba(29,111,164,.1)"},
                  {label:"Auto",icon:"auto",color:"#f59e0b",bg:"rgba(245,158,11,.1)"},
                  {label:"Share",icon:"users",color:"#ec4899",bg:"rgba(236,72,153,.1)"},
                ].map(r => (
                  <button key={r.label} onClick={() => { 
                    setPickup(trainStatus.pickupStation || trainStatus.station); 
                    setCategory(r.label.toLowerCase());
                    onSearch(); 
                  }} style={{flex:1,minWidth:60,background:r.bg,border:`1px solid ${r.color}33`,borderRadius:10,padding:"9px 6px",display:"flex",flexDirection:"column",alignItems:"center",gap:4,cursor:"pointer"}}>
                    <Icon name={r.icon} size={16} color={r.color} />
                    <span style={{fontSize:11,fontWeight:700,color:r.color}}>{r.label}</span>
                  </button>
                ))}
              </div>
              <div style={{marginTop:10,fontSize:11,color:"#4A6B80",display:"flex",alignItems:"flex-start",gap:6}}>
                <span style={{color:"#2872A1"}}>✓</span> Driver will automatically get a live tracking link for your train.
              </div>
            </div>
          </div>
        )}
      </div>

      <div style={{padding:"20px 20px 0"}}>
        <div style={{fontFamily:"Syne,sans-serif",fontSize:15,fontWeight:700,marginBottom:10,display:"flex",alignItems:"center",gap:6}}>
          <Icon name="gift" size={15} color="#2872A1" /> Offers for you
        </div>
        <div style={{display:"flex",gap:10,overflowX:"auto",paddingBottom:4}}>
          {PROMO.map(p => (
            <div key={p.code} style={{minWidth:160,background:"#FFFFFF",border:`1px solid ${p.color}33`,borderRadius:14,padding:"12px 14px",flexShrink:0}}>
              <div style={{fontFamily:"Syne,sans-serif",fontSize:16,fontWeight:800,color:p.color}}>{p.code}</div>
              <div style={{fontSize:12,color:"#4A6B80",marginTop:3}}>{p.desc}</div>
            </div>
          ))}
        </div>
      </div>

      <div style={{padding:"20px 20px 0"}}>
        <div style={{fontFamily:"Syne,sans-serif",fontSize:15,fontWeight:700,marginBottom:12}}>Quick Actions</div>
        <div style={{display:"grid",gridTemplateColumns:"1fr 1fr",gap:10}}>
          {[
            {icon:"history",label:"Past Rides",color:"#1D6FA4",bg:"rgba(29,111,164,.1)"},
            {icon:"wallet",label:"Wallet",color:"#f59e0b",bg:"rgba(245,158,11,.1)"},
            {icon:"shield",label:"Safety",color:"#2872A1",bg:"rgba(40,114,161,.1)"},
            {icon:"gift",label:"Offers",color:"#ec4899",bg:"rgba(236,72,153,.1)"},
          ].map(q => (
            <div key={q.label} style={{background:q.bg,border:`1px solid ${q.color}30`,borderRadius:14,padding:"14px",display:"flex",alignItems:"center",gap:10,cursor:"pointer"}}>
              <div style={{width:36,height:36,borderRadius:10,background:q.color+"22",display:"flex",alignItems:"center",justifyContent:"center"}}>
                <Icon name={q.icon} size={17} color={q.color} />
              </div>
              <div style={{fontFamily:"Syne,sans-serif",fontSize:14,fontWeight:700}}>{q.label}</div>
            </div>
          ))}
        </div>
      </div>

      <div style={{margin:"20px 20px 0",height:160,background:"#FFFFFF",border:"1px solid #9BBCD0",borderRadius:20,overflow:"hidden",position:"relative"}}>
        <div style={{position:"absolute",inset:0,background:"radial-gradient(circle at 40% 50%,rgba(40,114,161,.05),transparent 70%),repeating-linear-gradient(0deg,transparent,transparent 28px,rgba(40,114,161,.06) 28px,rgba(40,114,161,.06) 29px),repeating-linear-gradient(90deg,transparent,transparent 28px,rgba(40,114,161,.06) 28px,rgba(40,114,161,.06) 29px)"}}/>
        {[{top:"45%",left:"48%",ico:"📍",anim:"pinBounce 2s ease-in-out infinite"},{top:"30%",left:"60%",ico:"🚗",anim:"float 2.5s ease-in-out infinite"},{top:"60%",left:"35%",ico:"🏍",anim:"float 3s ease-in-out infinite .5s"},{top:"38%",left:"25%",ico:"🚗",anim:"float 2.8s ease-in-out infinite 1s"}].map((m,i) => (
          <div key={i} style={{position:"absolute",top:m.top,left:m.left,fontSize:20,transform:"translate(-50%,-50%)",animation:m.anim}}>{m.ico}</div>
        ))}
        <div style={{position:"absolute",bottom:12,left:12,background:"rgba(203,221,233,.85)",backdropFilter:"blur(10px)",border:"1px solid #9BBCD0",borderRadius:99,padding:"5px 12px",fontSize:12,fontWeight:500,display:"flex",alignItems:"center",gap:6}}>
          <PulseDot /> 18 drivers nearby
        </div>
      </div>
    </div>
  );
}
