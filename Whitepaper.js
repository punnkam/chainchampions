import React from "react";
import "./Whitepaper.css";
import Navbar from "../components/Navbar";

export default function Whitepaper() {
  return (
    <div className="Whitepaper">
      <Navbar></Navbar>
      <div className="whitepaper-container">
        <div className="text-container nes-container is-dark">
          <p>
            {" "}
            In a quest to conquer the arena we know as the metaverse, Chain
            Champions is a game that brings trailblazing game theory to the
            world of champions.{" "}
          </p>
        </div>
        <div className="text-container nes-container is-dark">
          <p>
            {" "}
            Training is not for the faint of heart. Each champion will train
            exhaustively to level up and acquire stronger gear through the
            infamously intensive Camp. Champions will earn EXP during training,
            and may find items during their outdoor sessions that will augment
            their strength in battle.
          </p>
          <br></br>
          <p>
            Champions can risk it all for the grand prizes in the Arena.
            Champions will have to fight against savage monsters, survive the
            harsh environments of varying terrains, and compete against other
            champions in their journey to win big. However, one unlucky mistake
            could cost them everything.
          </p>
        </div>
        <div className="text-container nes-container is-dark">
          <p>
            {" "}
            The start of your journey involves creating a team. There are two
            ways to get started: Mint a Champion with random properties, or
            acquire an existing Champion through marketplaces like OpenSea. Each
            champion is assigned a randomly-generated id on mint that determines
            their starting belongings: chestpiece, leggings, hat, cloak, and
            weapon. From there, it is up to you to lead your team to greatness.
            Champions can be staked in the Camp, where they will train and
            receive $EXP corresponding to their time in the Camp. $EXP is a
            valuable currency used to buy items, level up your character, or
            enter battles at the arena,. Champions can also enter the arena, a
            high risk battlefield where one can receive glory.{" "}
          </p>
        </div>
        <div className="text-container nes-container is-dark">
          <p>
            {" "}
            ROADMAP: The Chain Champions team created this game as a submission
            to NFTHack 2022. We have an broad 3-step vision for the future of
            Chain Champions. 1. We want complete the essential features of the
            game (Arena, Staking, and $EXP), as well connect the game to a
            captivating front-end seamlessly. 2. We will explore and implement
            game theory ideas for providing incentive and strategy to the game.
            Some of these ideas include: a marketplace for items, more dynamic
            arena environments, more assets for Champions, and more. 3. We want
            to convert Chain Champions into a self-sufficient DAO that innovates
            itself.
          </p>
        </div>
      </div>
    </div>
  );
}
