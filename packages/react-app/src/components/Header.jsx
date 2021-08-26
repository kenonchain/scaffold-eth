import React from "react";
import { PageHeader } from "antd";

export default function Header() {
  return (
    <a href="/" /*target="_blank" rel="noopener noreferrer"*/>
      <PageHeader
        title="🏗 scaffold-eth"
        subTitle="Challenge 1: Decentralized Staking App"
        style={{ cursor: "pointer" }}
      />
    </a>
  );
}
